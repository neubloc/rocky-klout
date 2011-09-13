require 'rubygems'
require 'json'
require 'httparty'
begin
  require 'cgi'
end

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# module RockyKlout
#   VERSION = '0.0.2'
# end

class RockyKlout
    include HTTParty
    VERSION = '0.0.2'
  
    @@base_uri = "http://api.klout.com"
    @@api_version = "1"
  
    @@api_key = ""
    
    def initialize(api_key)
      @@api_key = api_key
    end

    def api_key=(api)
      @@api_key = api
    end
  
    def api_key
      @@api_key
    end

    def score_klout(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/klout.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}"
      self.class.get(@@base_uri + request_uri)
    end
    
    def user_show(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/users/show.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}"
      self.class.get(@@base_uri + request_uri)
    end  
    
    def user_topics(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/users/topics.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}"
      self.class.get(@@base_uri + request_uri)
    end
    
    def user_stats(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/users/stats.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}"
      self.class.get(@@base_uri + request_uri)
    end
    
    def user_history(usernames_or_ids, measure, start_date, end_date)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/users/show.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}" +
        "&measure=" + CGI.escape(measure) +
        "&start_date=" + CGI.escape(start_date)
        "&end_date=" + CGI.escape(end_date)
      self.class.get(@@base_uri + request_uri)
    end
    
    def relationship_influenced_by(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/soi/influenced_by.json?key=#{@@api_key}&#{profile_method}=#{usernames_or_ids}"
      self.class.get(@@base_uri + request_uri)
    end
    
    def relationship_influencer_of(usernames_or_ids)
      usernames_or_ids, profile_method = parse_usernames([*usernames_or_ids])
      request_uri = "/#{@@api_version}/soi/influencer_of.json?key=#{@@api_key}&#{profile_method}="
      self.class.get(@@base_uri + request_uri)
    end
    
    def topic_search(topic)
      request_uri = "/#{@@api_version}/topics/search.json?key=#{@@api_key}&topic=" + CGI.escape(topic)
      self.class.get(@@base_uri + request_uri)
    end
    
    def topic_verify(topic)
      request_uri = "/#{@@api_version}/topics/verify.json?key=#{@@api_key}&topic=" + CGI.escape(topic)
      self.class.get(@@base_uri + request_uri)
    end
    
    private
    
    def parse_usernames(usernames_or_ids)
      if usernames_or_ids.all? { |username_or_id| username_or_id.is_a? Fixnum }
        return usernames_or_ids.join(","), "ids"
      elsif usernames_or_ids.all? { |username_or_id| username_or_id.is_a? String }
        return usernames_or_ids.collect{|name| CGI.escape(name)}.join(","), "users"
      else
        raise "usernames must be an array of strings or integers"
      end
    end
    
end