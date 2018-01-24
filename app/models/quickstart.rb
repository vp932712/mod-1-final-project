require 'pry'
# Sample Ruby code for user authorization

require 'rubygems'
# gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require_relative "../../config/secrets.rb"
require 'fileutils'
require 'json'


class YoutubeAdapter

  REDIRECT_URI = 'http://localhost'
  APPLICATION_NAME = 'YouTube Data API Ruby Tests'

  # REPLACE WITH NAME/LOCATION OF YOUR client_secrets.json FILE
  CLIENT_SECRETS_PATH = ENV["CLIENT_PATH"]

  # REPLACE FINAL ARGUMENT WITH FILE WHERE CREDENTIALS WILL BE STORED
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                               "youtube-quickstart-ruby-credentials.yaml")

  # SCOPE FOR WHICH THIS SCRIPT REQUESTS AUTHORIZATION
  SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY

  def self.search(search_input)


    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    puts "Input Search:"
    params = {:max_results=>10, :q=>gets.chomp, :type=>"song"}

    search_list_by_keyword(service,'snippet', params)

  end

  def self.authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
      puts "Open the following URL in the browser and enter the " +
           "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: REDIRECT_URI)
    end
    credentials
  end

  def self.search_list_by_keyword(service, part, params)
    params = params.delete_if { |p, v| v == ''}
    response = service.list_searches(part, params).to_json
    json_response = JSON.parse(response)
    items = json_response.fetch("items")
    no_playlists=[]
    urls=[]
    videos = items.select do |item|
      if item["id"]["videoId"] != nil
        no_playlists<<item
      end
    end
    counter=0
    no_playlists.each do |item|
      counter+=1
      urls<<"https://www.youtube.com/watch?v=#{item.fetch("id").fetch("videoId")}"
      puts ("#{counter}. #{item.fetch("snippet").fetch("title")}.
      ")
    end
    puts 'Choose a song'
    input=gets.chomp.to_i
     system("open #{urls[input-1]}")
  end

end


# # REPLACE WITH VALID REDIRECT_URI FOR YOUR CLIENT
# REDIRECT_URI = 'http://localhost'
# APPLICATION_NAME = 'YouTube Data API Ruby Tests'
#
# # REPLACE WITH NAME/LOCATION OF YOUR client_secrets.json FILE
# CLIENT_SECRETS_PATH = ENV["CLIENT_PATH"]
#
# # REPLACE FINAL ARGUMENT WITH FILE WHERE CREDENTIALS WILL BE STORED
# CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
#                              "youtube-quickstart-ruby-credentials.yaml")
#
# # SCOPE FOR WHICH THIS SCRIPT REQUESTS AUTHORIZATION
# SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY
#
# def authorize
#   FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
#
#   client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
#   token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
#   authorizer = Google::Auth::UserAuthorizer.new(
#     client_id, SCOPE, token_store)
#   user_id = 'default'
#   credentials = authorizer.get_credentials(user_id)
#   if credentials.nil?
#     url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
#     puts "Open the following URL in the browser and enter the " +
#          "resulting code after authorization"
#     puts url
#     code = gets
#     credentials = authorizer.get_and_store_credentials_from_code(
#       user_id: user_id, code: code, base_url: REDIRECT_URI)
#   end
#   credentials
# end
#
# # Initialize the API
#
# service = Google::Apis::YoutubeV3::YouTubeService.new
# service.client_options.application_name = APPLICATION_NAME
# service.authorization = authorize
#
# # Print response object as JSON
# # def print_results(response)
# #   puts response.to_json
# # end
#
# # Build a resource based on a list of properties given as key-value pairs.
# # def create_resource(properties)
# #   resource = {}
# #   properties.each do |prop, value|
# #     ref = resource
# #     prop_array = prop.to_s.split(".")
# #     for p in 0..(prop_array.size - 1)
# #       is_array = false
# #       key = prop_array[p]
# #       # For properties that have array values, convert a name like
# #       # "snippet.tags[]" to snippet.tags, but set a flag to handle
# #       # the value as an array.
# #       if key[-2,2] == "[]"
# #         key = key[0...-2]
# #         is_array = true
# #       end
# #       if p == (prop_array.size - 1)
# #         if is_array
# #           if value == ""
# #             ref[key.to_sym] = []
# #           else
# #             ref[key.to_sym] = value.split(",")
# #           end
# #         elsif value != ""
# #           ref[key.to_sym] = value
# #         end
# #       elsif ref.include?(key.to_sym)
# #         ref = ref[key.to_sym]
# #       else
# #         ref[key.to_sym] = {}
# #         ref = ref[key.to_sym]
# #       end
# #     end
# #   end
# #   return resource
# # end
#
# ### END BOILERPLATE CODE
#
# #Sample ruby code for search.list
# puts "Input Search:"
# params = {:max_results=>10, :q=>gets.chomp, :type=>"song"}
# def search_list_by_keyword(service, part, params)
#   params = params.delete_if { |p, v| v == ''}
#   response = service.list_searches(part, params).to_json
#   json_response = JSON.parse(response)
#   items = json_response.fetch("items")
#   no_playlists=[]
#   urls=[]
#   videos = items.select do |item|
#     if item["id"]["videoId"] != nil
#       no_playlists<<item
#     end
#   end
#   counter=0
#   no_playlists.each do |item|
#     counter+=1
#     urls<<"https://www.youtube.com/watch?v=#{item.fetch("id").fetch("videoId")}"
#     puts ("#{counter}. #{item.fetch("snippet").fetch("title")}.
#     ")
#   end
#   puts 'Choose a song'
#   input=gets.chomp.to_i
#    system("open #{urls[input-1]}")
# end
#
# search_list_by_keyword(service,'snippet', params)
#
#
#
#
#
# # Sample ruby code for channels.list
#
# # def channels_list_by_username(service, part, **params)
# #   response = service.list_channels(part, params).to_json
# #   item = JSON.parse(response).fetch("items")[0]
# #
# #   puts ("This channel's ID is #{item.fetch("id")}. " +
# #         "Its title is '#{item.fetch("snippet").fetch("title")}', and it has " +
# #         "#{item.fetch("statistics").fetch("viewCount")} views.")
# # end
# #
# # channels_list_by_username(service, 'snippet,contentDetails,statistics', for_username: 'GoogleDevelopers')
