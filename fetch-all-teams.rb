#!/usr/bin/env ruby

require_relative 'tba'
require 'date'
require 'json'

client = TbaClient.new
result = {}

# Many older data entries use abbreviated state/province names.
# Normalize to make the data cleaner
USA_STATE_ABBREVIATIONS = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PA' => 'Pennsylvania',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Islands',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}

CANADA_PROVINCE_ABBREVIATIONS = {
  'AB' => 'Alberta',
  'BC' => 'British Columbia',
  'MB' => 'Manitoba',
  'NS' => 'Nova Scotia',
  'ON' => 'Ontario',
  'QC' => 'Québec',
}


(1992..Date.today.year).each do |year|
  teams = client.get_teams_for_year(year)

  # many older data entries use abbreviated state names instead 
  teams.each do |team, i|
    if team['country'] == 'USA' && USA_STATE_ABBREVIATIONS.include?(team['state_prov'])
      team['state_prov'] = USA_STATE_ABBREVIATIONS[team['state_prov']]
    elsif team['country'] == 'Canada' && CANADA_PROVINCE_ABBREVIATIONS.include?(team['state_prov'])
      team['state_prov'] = CANADA_PROVINCE_ABBREVIATIONS[team['state_prov']]
    end
  end
  result[year] = teams
  puts "#{year}: #{teams.length} teams"
end

File.open 'output/all-teams.json', 'w' do |f|
  f.write result.to_json
end

puts "Cache misses: #{client.n_cache_miss}"
puts "Cache hit: #{client.n_cache_hit}"
puts "Cache refresh: #{client.n_cache_refresh}"
