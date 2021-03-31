require 'json'
SLEEP_TIME = 3
MAIN_MENU_MSG = 'Choose a number between 1-4 for the following actions:
1) New income
2) New expanse
3) Search a record
4) List all records

--> '

def read_from_file(filename)
  # General helper function to read from json file
  if File.file?(filename)
    file = File.read(filename)
    data_hash = JSON.parse(file)
  else
    data_hash = {}
  end
  data_hash
end

def write_to_file(filename, data)
  # General helper function to write data to json file.
  File.open(filename, 'w') do |f|
    f.write(data.to_json)
  end
end

def welcome_msg
  # Welcomes new user and get the user data (and later insert it to a user data json file).
  print 'Hello! Please enter your name: '
  name = gets.chomp

  print 'Please enter your budget (numbers only): '
  budget = Float(gets.chomp) rescue false
  until budget
    print "Wrong input. Please use digit only to enter your budget:\n"
    budget = Float(gets.chomp) rescue false
  end
  print "Great!\n"
  write_user_data_to_json(name, budget)
end

def print_hello_msg
  # prints hello msg with user data taken from json file.
  data_hash = read_from_file('user.json')
  puts "Hello #{data_hash['name']}! Your budget is #{data_hash['budget']}$"
end

def main_menu
  # App's main menu.
  data_hash = read_from_file('user.json')
  print "*** Current balance: #{data_hash['budget']}$ ***\n\n#{MAIN_MENU_MSG}"

  user_choice, is_number = extract_main_menu_choice
  until is_number && user_choice.to_i < 5 && user_choice.to_i.positive?
    print 'Wrong input. Please use digit from 1 to 4: '
    user_choice, is_number = extract_main_menu_choice
  end

  manage_sub_menu(user_choice)
end

def manage_sub_menu(user_choice)
  check_aborting_program(user_choice)

  if user_choice == 'menu'
    main_menu

  elsif user_choice.to_i == 1
    update_budget(1)

  elsif user_choice.to_i == 2
    update_budget(-1)

  elsif user_choice.to_i == 3
    print 'Please enter a search term: '
    search_term = gets.chomp
    list_records(search_term)

  elsif user_choice.to_i == 4
    list_records
  end

  sleep(SLEEP_TIME)
  print "\n"
  main_menu
end

def write_user_data_to_json(name, budget)
  # Creates a hash table and insert its data to a new json file.
  dict = {
    'name' => name,
    'budget' => budget
  }
  write_to_file('user.json', dict)
end

def update_budget_in_json(budget)
  # Update the user's budget in the existing json file.
  data_hash = read_from_file('user.json')
  data_hash['budget'] += budget
  write_to_file('user.json', data_hash)
end

def check_aborting_program(user_choice)
  abort('Bye Bye!') if user_choice == 'exit'
end

def extract_main_menu_choice
  user_choice = gets.chomp
  check_aborting_program(user_choice)
  is_number = Integer(user_choice) rescue false
  [user_choice, is_number]
end

def init_records_and_data(filename)
  records = []
  data_hash = {}

  # Checking if the file exists (first time using the app)
  if File.file?(filename)
    data_hash = read_from_file(filename)
    records = data_hash['records']
  end
  [records, data_hash]
end

def print_record_search(search_term, record_counter, record_descriptions)
  search_term = "for \"#{search_term}\"" if search_term != ''
  print "
Found #{record_counter} records #{search_term}:
-------------------------------
#{record_descriptions}"
end

def list_records(search_term = '', file_name = 'records.json', record_descriptions = '')
  records, = init_records_and_data(file_name)
  record_counter = 0

  records.each do |record|
    if record['description'].include? search_term
      sign = record['type'] == 'income' ? '+' : '-'
      record_descriptions += "#{record['description']} | #{sign}#{record['amount']}$\n"
      record_counter += 1
    end
  end
  print_record_search(search_term, record_counter, record_descriptions)
end

def update_records(type, amount, description = 'None', filename = 'records.json')
  # Update the user's budget records.
  records, data_hash = init_records_and_data(filename)

  record = {
    "type": type,
    "description": description,
    "amount": amount
  }
  records.append(record)
  data_hash['records'] = records
  write_to_file(filename, data_hash)
end

def update_budget(add_or_sub)
  type = add_or_sub == 1 ? 'income' : 'expanse'
  print "Adding new #{type}. Please insert the amount. You can also add an expanse description:\n"
  user_input = gets.chomp
  user_input = user_input.split(' ')

  amount = user_input[0].to_f
  description = 'None'
  description = user_input[1..-1].join(' ') if user_input.length > 1

  # Update new balance
  update_budget_in_json(amount * add_or_sub)

  # Update records
  update_records(type, amount, description)
  puts "Great! your #{type} is registered and recorded!"
end

welcome_msg
print_hello_msg
main_menu
