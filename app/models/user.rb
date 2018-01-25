class User < ActiveRecord::Base
  has_many :user_videos
  has_many :videos, through: :user_videos

  def self.search(user)
    puts "Please enter an artist or a song name"
    YoutubeAdapter.search(user)
  end

 def self.like(videoid, userid)
      UserVideo.where(["video_id = ? and user_id = ?", "#{videoid}", "#{userid}"]).update_all(liked: "true")

 end


  def self.video_options(input)
    case input
    when "1"
      like
    when "2"
      share
    when "3"
      self.user_choices
    when "4"
      exit
      # needs and exit function
    else
      "Please enter 1, 2, 3 or 4"
      User.video_options
    end
  end

  def like
      UserVideo.where(URl).update_all("like = 'true'")
  end


end
