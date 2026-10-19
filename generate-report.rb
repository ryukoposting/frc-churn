#!/usr/bin/env ruby

require_relative 'constants'
require 'csv'
require 'date'
require 'descriptive_statistics'
require 'gruff'
require 'json'

if ARGV.length == 0
  puts "Usage: generate-report.rb [all-region-json files]"
  exit 1
end

class Array
  # Returns an array of [ slope, pearson's correlation ]
  def least_squares(ydata)
    raise "xdata.length == ydata.length" unless self.length == ydata.length
    x_avg = Float(self.sum) / self.length
    y_avg = Float(ydata.sum) / ydata.length
    xdelta = self.map { |x| x - x_avg }
    ydelta = ydata.map { |y| y - y_avg }
    xydelta = xdelta.map.with_index { |x, i| x * ydelta[i] }
    xdelta_2 = xdelta.map { |x| x * x }
    ydelta_2 = ydelta.map { |y| y * y }
    slope = xydelta.sum / xdelta_2.sum
    correlation = xydelta.sum / (Math.sqrt(xdelta_2.sum) * Math.sqrt(ydelta_2.sum))
    [slope, correlation]
  end
end

regions = ARGV.map do |region_file|
  region_json = JSON.load File.open(region_file)
  region_csv = CSV.read "output/csv/#{region_json['key']}.csv", headers: true, converters: :float
  {
    key: region_json['key'],
    name: region_json['name'],
    region: region_json['region'],
    csv: region_csv
  }
end

regions_by_key = regions.map do |region|
  [region[:key], region]
end.to_h

def render_scatter(resolution, filename)
  g = Gruff::Scatter.new(resolution)
  g.theme = {
    background_colors: 'white',
    marker_color: '#888'
  }
  g.bottom_margin = 0
  g.label_margin = 5
  g.legend_position = :top_left
  yield g
  g.write("output/#{resolution}/#{filename}")
end

xdata = []
ydata = []
render_scatter('1280x800', 'young-vs-churn.png') do |g|
  g.title = "Churn vs Young Team Rate, by Region (2026)"
  g.y_axis_label = "Churn Moving Average"
  g.x_axis_label = "Percent Active Teams Age #{MAX_YOUNG_TEAM_EXPERIENCE} years or less, past 3 seasons"

  regions.map do |region|
    n_young = region[:csv]['young_active'][-3..].sum
    n_active = region[:csv]['active'][-3..].sum
    young_team_rate = n_young / n_active * 100
    churn_moving_avg = region[:csv][-1]['churn_moving_avg']

    # Color the outliers
    color, label =
      if region[:key] == 'china'
        ['#b11', region[:name]]
      elsif region[:key] == 'brazil'
        ['#1b1', region[:name]]
      elsif region[:key] == 'turkey'
        ['#b1b', region[:name]]
      else
        ['#11b', nil]
      end
    g.data label, young_team_rate, churn_moving_avg, color
    xdata << young_team_rate
    ydata << churn_moving_avg
  end
end
young_churn_m, young_churn_r, young_churn_p = xdata.least_squares(ydata)

xdata = []
ydata = []
render_scatter('1280x800', 'young-vs-young-churn.png') do |g|
  g.title = "Young Team Churn vs Young Teams, by Region (2026)"
  g.y_axis_label = "Young Team Churn Moving Average"
  g.x_axis_label = "Percent Active Teams Age #{MAX_YOUNG_TEAM_EXPERIENCE} years or less, past 3 seasons"

  regions.map do |region|
    n_young = region[:csv]['young_active'][-3..].sum
    n_active = region[:csv]['active'][-3..].sum
    young_team_rate = n_young / n_active * 100
    young_churn_moving_avg = region[:csv][-1]['young_churn_moving_avg']

    # Color the outliers
    color, label =
      if region[:key] == 'china'
        ['#b11', region[:name]]
      elsif region[:key] == 'brazil'
        ['#1b1', region[:name]]
      elsif region[:key] == 'turkey'
        ['#b1b', region[:name]]
      else
        ['#11b', nil]
      end
    g.data label, young_team_rate, young_churn_moving_avg, color
    xdata << young_team_rate
    ydata << young_churn_moving_avg
  end
end

render_scatter('1280x800', 'usa-young-vs-churn-by-year.png') do |g|
  g.title = "USA Active Young Teams vs. Churn, by Season"
  g.y_axis_label = "Churn Rate"
  g.x_axis_label = "Percent Active Teams Age #{MAX_YOUNG_TEAM_EXPERIENCE} years or less"
  g.legend_position = :top_right
  g.x_axis_increment = 5
  g.minimum_x_value = 15
  usa_csv = regions_by_key['usa'][:csv]
  active = usa_csv['active'][12..]
  young_active = usa_csv['young_active'][12..]
  churn = usa_csv['churn'][12..]
  xdata = young_active.zip(active).map { |d| d[0] / d[1] * 100 }
  g.data '2005-2020', xdata[0..15], churn[0..15], '#11b'
  g.data '2021-2023', xdata[16..18], churn[16..18], '#b11'
  g.data '2023-2026', xdata[19..], churn[19..], '#55d'
end

# render_scatter('1280x800', 'usa-experience-vs-churn-by-year.png') do |g|
#   g.title = "USA Experience vs. Churn, by Season"
#   g.y_axis_label = "Churn Rate"
#   g.x_axis_label = "Years of Experience"
#   g.minimum_x_value = 0
#   g.x_axis_increment = 10000
#   g.y_axis_increment = 5
#   usa_csv = regions_by_key['usa'][:csv]
#   experience = usa_csv['experience'][12..]#.map { |e| Math.log10(e) }
#   churn = usa_csv['churn'][12..]
#   g.data '2005-2020', experience[0..15], churn[0..15], '#11b'
#   g.data '2021-2023', experience[16..18], churn[16..18], '#b11'
#   g.data '2023-2026', experience[19..], churn[19..], '#55d'
# end

# render_scatter('1280x800', 'canada-experience-vs-churn-by-year.png') do |g|
#   g.title = "Canada Experience vs. Churn, by Season"
#   g.y_axis_label = "Churn Rate"
#   g.x_axis_label = "Years of Experience"
#   g.minimum_x_value = 0
#   g.x_axis_increment = 1000
#   g.y_axis_increment = 5
#   can_csv = regions_by_key['canada'][:csv]
#   experience = can_csv['experience'][12..]#.map { |e| Math.log10(e) }
#   churn = can_csv['churn'][12..]
#   g.data '2005-2020', experience[0..15], churn[0..15], '#11b'
#   g.data '2021-2023', experience[16..18], churn[16..18], '#b11'
#   g.data '2023-2026', experience[19..], churn[19..], '#55d'
# end

# render_scatter('1280x800', 'michigan-experience-vs-churn-by-year.png') do |g|
#   g.title = "Michigan Experience vs. Churn, by Season"
#   g.y_axis_label = "Churn Rate"
#   g.x_axis_label = "Years of Experience"
#   g.minimum_x_value = 0
#   g.x_axis_increment = 1000
#   g.y_axis_increment = 5
#   mi_csv = regions_by_key['michigan'][:csv]
#   experience = mi_csv['experience'][12..]#.map { |e| Math.log10(e) }
#   churn = mi_csv['churn'][12..]
#   g.data '2005-2020', experience[0..15], churn[0..15], '#11b'
#   g.data '2021-2023', experience[16..18], churn[16..18], '#b11'
#   g.data '2023-2026', experience[19..], churn[19..], '#55d'
# end

File.open('output/report.md', 'w') do |out|
  out.puts "# Churn Rate Report #{Date.today}"
  out.puts
  out.puts "## Young Team Rate vs. Churn"
  out.puts
  out.puts "- Each point represents one region."
  out.puts "- X axis: 3-year cumulative percent of active teams with #{MAX_YOUNG_TEAM_EXPERIENCE} experience or less."
  out.puts "- Y axis: moving average of churn rate."
  out.puts "- m=#{young_churn_m.round(3)} r2=#{(young_churn_r * young_churn_r).round(3)}"
  out.puts
  out.puts "![](1280x800/young-vs-churn.png)"
  out.puts
  out.puts "## USA Annual Churn Rate vs. Young Team Rate"
  out.puts
  out.puts "- Each point represents one season."
  out.puts "- X axis: percent of active teams with #{MAX_YOUNG_TEAM_EXPERIENCE} experience or less."
  out.puts "- Y axis: churn rate."
  out.puts
  out.puts "![](1280x800/usa-young-vs-churn-by-year.png)"
  out.puts
  out.puts "# Churn By Region"
  out.puts
  out.puts "Summary:"
  out.puts
  out.puts "| Region | 2026 Active Teams | 2026 Churn Rate | 2026 Churn Moving Average |"
  out.puts "| --- | --- | --- | --- |"
  regions.each do |region|
    out.puts "| #{region[:name]} | #{region[:csv][-1]['active']} | #{region[:csv][-1]['churn']}% | #{region[:csv][-1]['churn_moving_avg']}% |"
  end

  regions.each do |region|
    parent = regions_by_key[region[:region]] if region[:region]
    out.puts
    out.puts "## #{region[:name]}"
    out.puts
    out.puts "Statistics through 2026:"
    out.puts
    out.puts "- Experience: #{region[:csv][-1]['experience'].round(0)} team⋅years"

    n_active = region[:csv]['active'][-1].round(0)

    out.print "- Active teams: #{n_active}"
    out.puts(if parent
      active_percent = n_active / parent[:csv][-1]['active'] * 100
      " (#{active_percent.round(1)}% of #{parent[:name]})"
    end)

    n_young_3y = region[:csv]['young_active'][-3..].sum
    n_active_3y = region[:csv]['active'][-3..].sum
    young_team_rate = n_young_3y / n_active_3y * 100

    out.print "- 3-year young team rate: #{young_team_rate.round(1)}%"
    out.puts(if parent
      n_young_3y = parent[:csv]['young_active'][-3..].sum
      n_active_3y = parent[:csv]['active'][-3..].sum
      parent_young_team_rate = n_young_3y / n_active_3y * 100
      delta = young_team_rate - parent_young_team_rate
      if delta > 0.0
        " (#{delta.round(1)}% higher than #{parent[:name]})"
      else
        " (#{-delta.round(1)}% lower than #{parent[:name]})"
      end
    end)

    churn = region[:csv]['churn'][-1]

    out.print "- Churn rate: #{churn.round(1)}%"
    out.puts(if parent
      delta = churn - parent[:csv]['churn'][-1]
      if delta > 0.0
        " (#{delta.round(1)}% higher than #{parent[:name]})"
      else
        " (#{-delta.round(1)}% lower than #{parent[:name]})"
      end
    end)

    churn_moving_avg = region[:csv]['churn_moving_avg'][-1]

    out.print "- Churn rate moving average: #{churn_moving_avg.round(1)}%"
    out.puts(if parent
      delta = churn_moving_avg - parent[:csv]['churn_moving_avg'][-1]
      if delta > 0.0
        " (#{delta.round(1)}% higher than #{parent[:name]})"
      else
        " (#{-delta.round(1)}% lower than #{parent[:name]})"
      end
    end)

    out.puts
    out.puts "![Team Count Graph, #{region[:name]}](1280x800/teams/teams-#{region[:key]}.png)"
    out.puts "![Churn Rate Graph, #{region[:name]}](1280x800/churn/churn-#{region[:key]}.png)"
  end
end
