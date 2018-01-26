require "pry"
class Cli

  attr_accessor :current_user, :email, :name

  def initilalize
    @current_user = nil
    @email = email
    @name = name
  end

  def welcome

    puts
    puts "Are you a new user or an existing user ? \n\nPlease choose from the following options:\n\n1. New User  \n2. Existing User \n3. Exit"
    input = gets.chomp
    case input
    when "1"
      create_new_user_cli
    when "2"
      login
    when "3"
      exit_the
    else
      "Enter either 1 or 2"
      welcome
    end
  end

  def create_new_user_cli
    user = {}
    puts "Please enter your E-mail"
    puts
    user[:email] = gets.chomp
    puts "Please enter your Name"
    puts
    user[:name] = gets.chomp
    self.current_user = User.find_or_create_by(user)
    user_choices
  end

  def login
    puts "Please enter your email"
    puts
    email_address = gets.chomp
    if (User.find_by(email: email_address))
      self.current_user = User.find_by(email: email_address)
      puts "Welcome back!"
      puts
      user_choices
    else
      puts "Please check your email and try again"
      puts
      login
    end
  end

  def user_choices
    puts "Please choose from the following options:"
    puts
    puts "1.Search for a Song \n2.Exit\n3.messages"
    input = gets.chomp
    case input
    when "1"
      search
    when "2"
      exit_the
    when "3"
      message
    else
      puts "Enter either 1 or 2"
      user_choices
    end
  end

  def search
    User.search(self.current_user, self)
  end

  def video_options(input)

    case input
    when "1"
      like
      user_choices

    when "2"
      share
    when "3"
     user_choices
    when "4"
      exit_the
      # neds and exit function
    else
      "Please enter 1, 2, 3 or 4"
     video_options
    end

  end

  def like
    videoid = current_user.user_videos.last.video_id
    userid = current_user.id
    User.like(videoid, userid)

  end

  def watch_videos
    description = []
    url = []
    current_user.videos.each do |obj|
      description.push(obj.description)
      url.push(obj.URL)
    end
    description.each do |str|
      puts "#{str}"
    end

  end

  def liked_videos
    url = []
    description = []
    arr = current_user.user_videos.select do |obj|
        obj.liked == true
     end
     arr1 = arr.collect do |obj|
       obj.video_id
     end.uniq
     video_arr = Video.find(arr1)
     video_arr.each do |obj|
       description << obj.description
       url << obj.URL
     end
     counter = 0
     description.each do |str|
       counter += 1
       puts "#{counter}. #{str}"

     end
     puts "#{counter+1}. Main Menu \n\n#{counter+2}. Exit"
     puts
     puts "Choose a song that you would like to play"


     input=gets.chomp.to_i
     case input
     when counter+1
      user_choices
     when counter+2
       # self.exit
       # need an exit method
     else
      system("open #{url[input-1]}")
      user_choices
    end
      end


      def share
        puts "Enter your friend's email"
        input = gets.chomp
       receivers_info =  User.find_by(email: input)
        receivers_info.id
        puts "Enter a message to send.."
        msg = gets.chomp
        videoid = current_user.user_videos.last.video_id
        SharedMessage.create(video_id: videoid, user_id: current_user.id, receivers_id: receivers_info.id , message: msg)
        user_choices
      end


      def message
        obj = SharedMessage.find_by(receivers_id: current_user.id)
        puts "#{obj.message}"
       video = Video.find(obj.video_id)
       puts "#{video.description}"
       puts "1.play 2.exit"
       input = gets.chomp
       case input
       when "1"
         system("open #{video.URL}")
         user_choices
       when "2"
         user_choices
       else
         puts "invalid"
       end

      end



  def exit_the
    puts "Good-bye!!"
    exit
    # "Good-bye"
  end




end
