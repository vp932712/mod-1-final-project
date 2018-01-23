class User < ActiveRecord::Base
  has_many :user_videos
  has_many :vidoes, through: :user_videos
end
