class Video < ActiveRecord::Base
  has_many :user_videos
  has_many :users, through: :user_videos

  def views(url_string)
    Video.find_by(url: url_string)
  end

end
