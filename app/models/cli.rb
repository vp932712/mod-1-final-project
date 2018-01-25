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
      exit
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
    puts "1.Search for a Song \n2.Exit"
    input = gets.chomp
    case input
    when "1"
      search
    when "2"
      exit
    else
      "Enter either 1 or 2"
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

    when "2"
      share
    when "3"
     user_choices
    when "4"
      exit
      # needs and exit function
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






  def exit
    "Good-bye"
  end




end
