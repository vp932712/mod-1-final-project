class User < ActiveRecord::Base
  has_many :user_videos
  has_many :videos, through: :user_videos

  def self.search(user, cli)
    puts "Please enter an artist or a song name"
    YoutubeAdapter.search(user, cli)
  end


 def self.like(videoid, userid)
      UserVideo.where(["video_id = ? and user_id = ?", "#{videoid}", "#{userid}"]).update_all(liked: "true")

 end










end
