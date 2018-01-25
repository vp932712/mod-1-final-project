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

  def self.search(user)


    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize


    params = {:max_results=>10, :q=>gets.chomp, :type=>"song"}

    search_list_by_keyword(service,'snippet', params, user)

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

  def self.search_list_by_keyword(service, part, params, user)
    params = params.delete_if { |p, v| v == ''}
    response = service.list_searches(part, params).to_json
    json_response = JSON.parse(response)
    items = json_response.fetch("items")
    no_playlists=[]
    urls=[]
    desc = []
    videos = items.select do |item|
      if item["id"]["videoId"] != nil
        no_playlists<<item
      end
    end
    puts 'Choose a song, redo, or exit'
    puts
    counter=0
    no_playlists.each do |item|
      counter+=1
      desc << "#{item.fetch("snippet").fetch("title")}"
      urls<<"https://www.youtube.com/watch?v=#{item.fetch("id").fetch("videoId")}"
      puts ("#{counter}. #{item.fetch("snippet").fetch("title")}.
      ")

    end
    puts "#{counter+1}. Redo a search \n\n#{counter+2}. Exit"

    input=gets.chomp.to_i
    case input
    when counter+1
      User.search(user)
    when counter+2
      # self.exit
      # need an exit method
    else
     system("open #{urls[input-1]}")
     video = Video.create_new_video(urls[input-1], desc[input-1] )

     UserVideo.create_new_user_video(user.id, video.id)
     self.video_options

   end

  end



end
