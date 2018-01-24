class Cli

  attr_accessor :current_user

  def initilalize
    @current_user = nil
  end

  def welcome
    puts "Are you a 1.New User or an 2.Existing User"
    input = gets.chomp
    case input
    when "1"
      create_new_user_cli
    when "2"
      login
    else
      "Enter either 1 or 2"
      welcome
    end
  end

  def create_new_user_cli
    puts "Please enter your E-mail"
    email = gets.chomp
    puts "Please enter your Name"
    name = gets.chomp
    User.create_new_user(email, name)
  end

  def login
    puts "Please enter your email"
    email = gets.chomp
    User.find_user(email)
    puts "Welcome back!"
  end






end
