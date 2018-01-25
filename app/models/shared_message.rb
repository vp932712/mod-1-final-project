class SharedMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :video


  def self.share_new_message(videoid, userid, receiverid, str_msg)
    SharedMessage.create(video_id: videoid, user_id: userid, receivers_id: receiverid, message: str_msg)
  end


  


end
