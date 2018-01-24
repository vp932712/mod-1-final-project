require "pry"

class User < ActiveRecord::Base
  has_many :user_videos
  has_many :vidoes, through: :user_videos



  def self.find_user(credentials_input)
    User.find_by(email: credentials_input)

  end

  def self.create_new_user(email, name)
    User.create(:email => email, :name =>name)


  end

Pry.start

  #
  # def search(search_input)
  #
  #
  # end
  #
  #
  # def play
  #
  # end
  #
  #
  # def like
  #
  # end
  #






end
