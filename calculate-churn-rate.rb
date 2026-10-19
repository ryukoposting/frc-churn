#!/usr/bin/env ruby

require_relative 'constants'
require 'date'
require 'json'
require 'gruff'

if ARGV.length != 1
  puts "Usage: calculate-churn-rate.rb [region_json_file]"
end

# Only god knows why this isn't built in
module Fold
  def fold(accumulator)
    map do |value|
      accumulator = yield(accumulator, value)
    end
  end
end

class Array
  include Fold
end

class Range
  include Fold
end

jsondata = JSON.load File.open(ARGV[0])
region_key = jsondata['key']
region_name = jsondata['name']
raw_data = jsondata['data']

# active_teams := List<List<all active teams>>
# Sibling teams will show up numbered as the big sibling.
# Example: starting from 2025, instead of frc1220 and frc1732
# you will see frc1732 in the list twice. That's how the
# script compensates for sibling teams and rebrands. If a
# sibling team goes dormant, it does not count against churn
# as long as there is at least one of its siblings is active.
active_teams = (1992..Date.today.year).map do |year|
  team_keys = raw_data[year.to_s] || []
  team_keys.each_with_index do |team_key, index|
    rebrand = SAME_PROGRAM_TEAMS[team_key]
    if rebrand && (rebrand[1].nil? || rebrand[1] <= year) && (rebrand[2].nil? || rebrand[2] >= year)
      team_keys[index] = rebrand[0]
    end
  end
end

# n_active_teams := List<# of active teams>
n_active_teams = active_teams.map do |team_keys|
  team_keys.length
end

# n_active_teams := List<# of accumulated years of experience in the region>
accumulate_experience = 0
n_region_experience = n_active_teams.map do |n_teams|
  accumulate_experience += n_teams
  accumulate_experience - n_teams
end

# First index into the lists that meets the minimum years of experience
# exception made for FMA because it met the experience threshold long before it
# became a district
first_eligible = n_region_experience.find_index do |experience|
  experience >= MIN_REGION_EXPERIENCE or region_key == 'fma'
end

# previous_teams := List<Set<teams that have ever been active at least once before the season>>
previous_teams = [Set.new]
previous_teams += active_teams.fold(Set.new) do |acc, team_keys|
  acc + Set.new(team_keys)
end
all_teams = previous_teams.pop

# rookie_teams := List<List<rookie teams>>
rookie_teams = active_teams.each_with_index.map do |team_keys, index|
  prev_teams = previous_teams[index]
  team_keys.filter do |team_key|
    !prev_teams.include?(team_key)
  end
end

# n_rookie_teams := List<# of rookie teams>
n_rookie_teams = rookie_teams.map do |team_keys|
  team_keys.length
end

# veteran_teams := List<List<veteran teams>>
veteran_teams = active_teams.each_with_index.map do |team_keys, index|
  if index == 0
    []
  else
    last_year = active_teams[index - 1]
    team_keys.filter do |team_key|
      last_year.include?(team_key)
    end
  end
end

# n_veteran_teams := List<# of veteran teams>
n_veteran_teams = veteran_teams.map do |team_keys|
  team_keys.length
end

# returning_teams := List<List<returning teams>>
returning_teams = active_teams.each_with_index.map do |team_keys, index|
  if index == 0
    []
  else
    last_year = active_teams[index - 1]
    prev_teams = previous_teams[index]
    team_keys.filter do |team_key|
      prev_teams.include?(team_key) && !last_year.include?(team_key)
    end
  end
end

# n_returning_teams := List<# of returning teams>
n_returning_teams = returning_teams.map do |team_keys|
  team_keys.length
end

# dormant_teams := List<List<dormant teams>>
dormant_teams = active_teams.each_with_index.map do |team_keys, index|
  if index == 0
    []
  else
    last_year = active_teams[index - 1]
    last_year.filter do |team_key|
      !team_keys.include? team_key
    end
  end
end

# n_dormant_teams := List<# of dormant teams>
n_dormant_teams = dormant_teams.map do |team_keys|
  team_keys.length
end

# team_experience := Map<team, number of active seasons> (sibling duplicates don't count for extra)
team_experience = all_teams.map do |team_key|
  n_seasons = active_teams.count { |team_keys| team_keys.include? team_key }
  [team_key, n_seasons]
end.to_h

# subset of returning teams <= 3 years old
young_returning_teams = returning_teams.map.with_index do |team_keys, index|
  team_keys.select do |team_key|
    prior_experience = active_teams[0...index].count { |team_keys| team_keys.include? team_key }
    prior_experience <= MAX_YOUNG_TEAM_EXPERIENCE
  end
end

n_young_returning_teams = young_returning_teams.map do |team_keys|
  team_keys.length
end

# subset of dormant teams <= 3 years old
young_dormant_teams = dormant_teams.map.with_index do |team_keys, index|
  team_keys.select do |team_key|
    prior_experience = active_teams[0...index].count { |team_keys| team_keys.include? team_key }
    prior_experience <= MAX_YOUNG_TEAM_EXPERIENCE
  end
end

n_young_dormant_teams = young_dormant_teams.map do |team_keys|
  team_keys.length
end

young_active_teams = active_teams.map.with_index do |team_keys, index|
  team_keys.select do |team_key|
    prior_experience = active_teams[0...index].count { |team_keys| team_keys.include? team_key }
    prior_experience <= MAX_YOUNG_TEAM_EXPERIENCE
  end
end

n_young_active_teams = young_active_teams.map do |team_keys|
  team_keys.length
end

# previous_teams := List<churn rates>
churn = (0...n_active_teams.length).map do |index|
  if index == 0 || n_active_teams[index - 1] == 0
    0
  else
    100.0 * (n_returning_teams[index] + n_dormant_teams[index]) / (n_active_teams[index - 1])
  end
end

# Moving average of churn rate
churn_moving_avg = churn.fold(churn[0]) do |acc, val|
  (acc + val) / 2.0
end

young_churn = (0...n_active_teams.length).map do |index|
  if index == 0 || n_active_teams[index - 1] == 0
    0
  else
    100.0 * (n_young_returning_teams[index] + n_young_dormant_teams[index]) / (n_active_teams[index - 1])
  end
end

young_churn_moving_avg = young_churn.fold(young_churn[0]) do |acc, val|
  (acc + val) / 2.0
end

old_churn = (0...n_active_teams.length).map do |index|
  churn[index] - young_churn[index]
end

first_year = first_eligible + 1992

puts "#{region_name} - Start year: #{first_year} (#{n_active_teams[first_eligible]} Teams)"
puts "Returning teams for #{Date.today.year}: #{returning_teams[-1].join(', ')}"
puts "Rookie teams for #{Date.today.year}: #{rookie_teams[-1].join(', ')}"
puts "Dormant teams for #{Date.today.year}: #{dormant_teams[-1].join(', ')}"

# CSV file rendering
File.open("output/csv/#{region_key}.csv", 'w') do |f|
  f.puts "year,region_key,experience,active,veteran,returning,rookie,dormant,young_active,young_returning,young_dormant,churn,young_churn,churn_moving_avg,young_churn_moving_avg"
  (1993..Date.today.year).each.with_index(1) do |year, index|
    # next unless n_active_teams[index - 1] > 0
    f.write "#{year},"
    f.write "#{region_key},"
    f.write "#{n_region_experience[index]},"
    f.write "#{n_active_teams[index]},"
    f.write "#{n_veteran_teams[index]},"
    f.write "#{n_returning_teams[index]},"
    f.write "#{n_rookie_teams[index]},"
    f.write "#{n_dormant_teams[index]},"
    f.write "#{n_young_active_teams[index]},"
    f.write "#{n_young_returning_teams[index]},"
    f.write "#{n_young_dormant_teams[index]},"
    f.write "#{churn[index].round(2)},"
    f.write "#{young_churn[index].round(2)},"
    f.write "#{churn_moving_avg[index].round(2)},"
    f.write "#{young_churn_moving_avg[index].round(2)}"
    f.puts
  end
end

# Bar graph rendering
def get_year_label(year)
  if year % 5 == 0
    "'" + (year % 100).to_s.rjust(2, '0')
  else
    ""
  end
end

def render_graph(resolution, filename)
  g = Gruff::StackedBar.new(resolution)
  g.theme = {
    background_colors: 'white',
    marker_color: '#888'
  }
  g.bottom_margin = 0
  g.label_margin = 5
  g.legend_position = :top_left
  yield g
  g.write(filename)
end

render_graph('1280x800', "output/1280x800/teams/teams-#{region_key}.png") do |g|
  g.title = region_name
  g.y_axis_label = "Active Teams"
  g.x_axis_label = "Year"
  g.data 'Rookies', n_rookie_teams, '#44c'
  g.data 'Veterans', n_veteran_teams, '#11b'
  g.data 'Returning', n_returning_teams, '#1b1'
  g.data 'Dormant', n_dormant_teams, '#f002'
  g.labels = (1992..Date.today.year).map { |year| get_year_label(year) }
end

render_graph('1280x800', "output/1280x800/churn/churn-#{region_key}.png") do |g|
  g.title = region_name
  g.maximum_value = [churn[first_eligible..].max, 40].max
  g.minimum_value = 0
  g.y_axis_label = "Churn (Percent of Active Teams)"
  g.x_axis_label = "Year"
  g.data "Young Teams (<= #{MAX_YOUNG_TEAM_EXPERIENCE} active seasons)", young_churn[first_eligible..], '#44c'
  g.data 'Experienced Teams', old_churn[first_eligible..], '#11b'
  g.labels = (first_year..Date.today.year).map { |year| get_year_label(year) }
end
