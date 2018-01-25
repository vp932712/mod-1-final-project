class User < ActiveRecord::Base
  has_many :user_videos
  has_many :videos, through: :user_videos

  # def self.find_user(credentials_input)
  #   User.find_by(email: credentials_input)
  # end
  #
  # def self.create_new_user(email, name)
  #   User.create(:email => email, :name =>name)
  # end


  def self.search(user)
    puts "Please enter an artist or a song name"
    YoutubeAdapter.search(user)
  end


  def play
  end


  def like
  end

end
