#!/usr/bin/env ruby

require_relative 'tba'
require 'json'
require 'optparse'

if ARGV.length < 2
  puts "Usage: fetch-city.rb [--region region] [key] [name] [city state...]"
  exit 1
end

options = {}
OptionParser.new do |opt|
  opt.on('--region REGION') { |o| options[:region] = o }
end.parse!

all_teams = JSON.load File.open('output/all-teams.json')
data = {}

def team_matches?(team)
  2.step(ARGV.length, 2).each do |i|
    city = ARGV[i]
    state = ARGV[i+1]
    if team['state_prov'] == state and team['city'] == city
      return true
    end
  end
  false
end

all_teams.each do |year, teams|
  data[year] = []
  teams.each do |team|
    data[year] << team['key'] if team_matches?(team)
  end
  puts "#{year}: #{data[year].length} teams"
end

result_map = {
  key: ARGV[0],
  name: ARGV[1],
  data: data
}

if options[:region]
  result_map[:region] = options[:region]
end

File.open("output/regions/#{ARGV[0]}.json", 'w') do |f|
  f.write result_map.to_json
end
