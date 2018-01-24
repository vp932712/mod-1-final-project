require "pry"
class Cli

  attr_accessor :current_user, :email, :name

  def initilalize
    @current_user = nil
    @email = email
    @name = name
  end

  def welcome
    puts "Are you a 1.New User or an \n2.Existing User \n3.Exit"
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
    user[:email] = gets.chomp
    puts "Please enter your Name"
    user[:name] = gets.chomp
    self.current_user = User.find_or_create_by(user)
    user_choices
  end

  def login
    puts "Please enter your email"
    email_address = gets.chomp
    self.current_user = User.find_by(email: email_address)
    puts "Welcome back!"
    user_choices
  end

  def user_choices
    puts "Please choose from the following options:"
    puts "1.Search for a Song \n2.Exit"
    input = gets.chomp
    case input
    when "1"
      search
# put a function that is going to search for a song
    when "2"
      exit
    else
      "Enter either 1 or 2"
      user_choices
    end
  end

  def search
    User.search
  end


  def exit
    "Good-bye"
  end




end
