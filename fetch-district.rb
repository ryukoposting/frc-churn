#!/usr/bin/env ruby

require 'optparse'
require_relative 'tba'

if ARGV.length < 2
  puts "Usage: fetch-district.rb [key] [description]"
  puts "Example: fetch-district.rb mar 'Mid-Atlantic'"
  exit 1
end

options = {}
OptionParser.new do |opt|
  opt.on('--region REGION') { |o| options[:region] = o }
end.parse!

client = TbaClient.new

history = client.get_district_history(ARGV[0])

data = {}

history.each do |hist|
  key = hist['key']

  raise "unexpected key format #{key}" unless key =~ /([0-9]{4})[a-z]+/
  data[$1] = client.get_district_teams(key).map do |team_year|
    team_year['key']
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
