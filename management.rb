require 'json'

def welcome_msg
  # Welcomes new user and get the user data (and later insert it to a user data json file).
  print "Hello! Please enter your name:\n"
  name = gets.chomp

  print "Please enter your budget (numbers only):\n"
  budget = Float(gets.chomp) rescue false
  until budget
    print "Wrong input. Please use digit only to enter your budget:\n"
    budget = Float(gets.chomp) rescue false
  end
  print "Great!\n"
  write_user_data_to_json(name, budget)
end

def write_user_data_to_json(name, budget)
  # Creates a hash table and insert its data to a new json file.
  dict = {
    "name" => name,
    "budget" => budget,
    "balance" => budget
  }
  File.open("user.json","w") do |f|
    f.write(dict.to_json)
  end
end

def print_hello_msg
  # prints hello msg with user data taken from json file.
  file = File.read('user.json')
  data_hash = JSON.parse(file)
  puts "Hello #{data_hash["name"]}! Your budget is #{data_hash["budget"]}$"
end

def check_aborting_program(user_choice)
  if user_choice == "exit"
    abort("Bye!")
  end
end

def main_menu
  file = File.read('user.json')
  data_hash = JSON.parse(file)

  msg = "*** Current balance: #{data_hash["balance"]}$ ***

Choose a number between 1-4 for the following action:
1) New income
2) New expanse
3) Search a record
4) List all records

-->"

  puts msg
  user_choice, is_number = extract_main_menu_choice

  until is_number && user_choice.to_i < 5 && user_choice.to_i > 0
    print "Wrong input. Please use digit from 1 to 4:\n"
    user_choice, is_number = extract_main_menu_choice
  end

  manage_sub_menu(user_choice)
end

def extract_main_menu_choice
  user_choice = gets.chomp
  check_aborting_program(user_choice)
  is_number = Integer(user_choice) rescue false
  [user_choice, is_number]
end

def update_balance(add_or_sub)
  amount_to_add = gets.chomp

  # Update new balance
  # Update records
  # Redirect to main menu
end

def manage_sub_menu(user_choice)
  puts "Great!"
  if user_choice == 1
    puts "Adding new income, Please insert the amount to add to your balance:\n"
    update_balance(1)

    user_choice == 2
    puts "Adding new expanse, Please insert the amount to reduce from your balance:\n"
    update_balance(-1)

  elsif  user_choice == "menu"
    main_menu
  end
end


# welcome_msg
# print_hello_msg
main_menu
