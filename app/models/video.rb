class Video < ActiveRecord::Base
  has_many :user_videos
  has_many :users, through: :user_videos

  def self.create_new_video(url_string, des_str)
    if  Video.find_by(URL: url_string)
      video = Video.find_by(URL: url_string)
      video.views +=1
      video.save
      video
    else
      Video.create(description: des_str, URL: url_string, views: 1)
    end
  end




  # def self.show_views()
  #   Video.find_by(url: url_string)
  # end

end
