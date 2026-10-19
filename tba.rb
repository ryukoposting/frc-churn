require 'net/http'
require 'json'

TBA_AUTH_KEY = 'RMzdZ4ycoReR7Zu6ooNGkc7IZAN952wH0LnNyiDbvxQdEtzr1Lv13W6F8Equ3dCZ'

class TbaClient
  attr_accessor :n_cache_hit
  attr_accessor :n_cache_miss
  attr_accessor :n_cache_refresh

  def initialize(cache_path='cache/tbaclient-cache.json')
    @auth_key = TBA_AUTH_KEY
    @endpoint = URI('https://www.thebluealliance.com/api/v3')
    @cache = RequestCache.new(cache_path)
    @n_cache_hit = 0
    @n_cache_miss = 0
    @n_cache_refresh = 0
  end

  def do_http_get(path)
    url = @endpoint.clone
    url.path = path
    req = Net::HTTP::Get.new(url)
    req['X-TBA-Auth-Key'] = @auth_key

    etag = @cache.fetch_etag(url.to_s)
    req['If-None-Match'] = etag if etag

    resp = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(req)
    end

    if resp.is_a? Net::HTTPSuccess
      if etag
        @n_cache_miss += 1
      else
        @n_cache_refresh += 1
      end
      etag = resp['ETag']
      data = JSON.parse resp.body
      @cache.submit(url.to_s, etag, data)
      @cache.save
      return data
    elsif resp.is_a? Net::HTTPNotModified
      @n_cache_miss += 1
      return @cache.fetch_data(url.to_s)
    else
      raise resp.code_type
    end
  end

  def get_years_participated(team)
    team = team.to_s
    do_http_get "/api/v3/team/#{team.to_team_id}/years_participated"
  end

  def get_district_teams(district_year_key)
    do_http_get "/api/v3/district/#{district_year_key}/teams"
  end

  def get_district_history(district)
    do_http_get "/api/v3/district/#{district}/history"
  end

  def get_teams_for_year(year)
    page = 0
    teams = [1]
    result = []
    while teams.length != 0
      puts "Fetching page #{page} of teams for year #{year}..."
      teams = do_http_get "/api/v3/teams/#{year}/#{page}/simple"
      result.concat(teams)
      page += 1
    end
    result
  end
end

class RequestCache
  def initialize(file)
    @dirty = false
    @filename = file
    if File.exist?(file)
      @cache = JSON.parse File.read(file)
    else
      @cache = {}
    end
  end

  def raw
    @cache
  end

  def submit(request_path, etag, data)
    return if @cache[request_path] and @cache[request_path][:etag] == etag
    @dirty = true
    @cache[request_path] = {
      'etag' => etag,
      'data' => data
    }
  end

  def fetch_etag(request_path)
    @cache[request_path]['etag'] if @cache[request_path]
  end

  def fetch_data(request_path)
    @cache[request_path]['data'] if @cache[request_path]
  end

  def save
    return unless dirty?
    File.open(@filename, 'w') do |f|
      f.write @cache.to_json
    end
  end

  def dirty?
    @dirty
  end
end

class String
  def to_team_id
    if self.start_with? 'frc'
      self
    else
      "frc#{self}"
    end
  end
end
