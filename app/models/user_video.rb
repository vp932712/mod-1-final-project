class UserVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :video


  def self.create_new_user_video(user_id, video_id)
    UserVideo.create(user_id: user_id, video_id: video_id, watched: true, liked: false, share: nil)

  end
end
