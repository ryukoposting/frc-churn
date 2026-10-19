#!/usr/bin/env ruby

require_relative 'tba'
require 'json'
require 'optparse'

if ARGV.length < 2
  puts "Usage: fetch-state.rb [--region REGION] [key] [name] [states...]"
  exit 1
end

options = {}
OptionParser.new do |opt|
  opt.on('--region REGION') { |o| options[:region] = o }
end.parse!

all_teams = JSON.load File.open('output/all-teams.json')
data = {}

all_teams.each do |year, teams|
  data[year] = []
  teams.each do |team|
    data[year] << team['key'] if ARGV[2..].include? team['state_prov']
  end
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
