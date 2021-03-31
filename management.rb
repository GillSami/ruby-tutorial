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
  }
  File.open("user.json","w") do |f|
    f.write(dict.to_json)
  end
end

def update_budget_to_json(budget)
  # Update the user's budget and update the existing json file.
  file = File.read('user.json')
  data_hash = JSON.parse(file)

  data_hash["budget"] += budget

  File.open("user.json","w") do |f|
    f.write(data_hash.to_json)
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
    abort("Bye Bye!")
  end
end

def main_menu
  file = File.read('user.json')
  data_hash = JSON.parse(file)

  msg = "*** Current balance: #{data_hash["budget"]}$ ***

Choose a number between 1-4 for the following action:
1) New income
2) New expanse
3) Search a record
4) List all records

-->"

  print msg
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

def update_records(type, amount, description = "None", file_name = 'records.json')
  # Update the user's budget records.
  records = []
  data_hash = Hash.new

  #Checking if the file exists (first time using the app)
  if File.file?(file_name)
    file = File.read(file_name)
    data_hash = JSON.parse(file)
    records = data_hash["records"]
  end

  record = {
    "type": type,
    "description": description,
    "amount": amount
  }
  records.append(record)
  data_hash["records"] = records

  File.open(file_name,"w") do |f|
    f.write(data_hash.to_json)
  end
end

def update_budget(add_or_sub)
  user_input = gets.chomp
  user_input = user_input.split(" ")

  amount = user_input[0].to_f
  description = "None"
  if user_input.length > 1
    description = user_input[1..-1].join(" ")
  end

  # Update new balance
  update_budget_to_json(amount * add_or_sub)

  # Update records
  if add_or_sub == 1
    type = "income"
  else
    type = "expanse"
  end
  update_records(type, amount, description)

  # Redirect to main menu
end

def manage_sub_menu(user_choice)
  check_aborting_program(user_choice)

  if  user_choice == "menu"
    main_menu

  elsif user_choice.to_i == 1
    print "Adding new income. Please insert the amount. You can also add an expanse description:\n"
    update_budget(1)

  elsif user_choice.to_i == 2
    print "Adding new expanse.\n Please insert the amount. You can also add an expanse description:\n"
    update_budget(-1)
  end
end


# welcome_msg
# print_hello_msg
main_menu
