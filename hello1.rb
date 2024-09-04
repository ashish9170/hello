require 'securerandom'

def generate_account_number
  SecureRandom.random_number(10**14).to_s.rjust(14, '0')
end

def register(accounts, usernames)
  print "Enter your first name: "
  first_name = gets.chomp
  print "Enter your age: "
  age = gets.chomp.to_i
  print "Enter your PIN: "
  pin = gets.chomp

  username = ''
  loop do
    print "Enter a unique username: "
    username = gets.chomp
    if usernames.key?(username)
      puts "Username already exists. Please choose a different username."
    else
      break
    end
  end

  account_number = generate_account_number
  accounts[account_number] = {
    first_name: first_name,
    age: age,
    pin: pin,
    balance: 0.0,
    username: username
  }
  usernames[username] = account_number

  puts "Registration successful! Your account number is #{account_number}."
end

def login(accounts, usernames)
  print "Enter your username or account number: "
  input = gets.chomp

  account_number = usernames[input] || input
  account = accounts[account_number]

  if account
    print "Enter your PIN: "
    pin = gets.chomp
    if account[:pin] == pin
      puts "Login successful!"
      account[:account_number] = account_number
      account
    else
      puts "Invalid PIN."
      nil
    end
  else
    puts "Invalid username or account number."
    nil
  end
end

def deposit(account, amount)
  account[:balance] += amount
end

def withdraw(account, amount)
  if amount > account[:balance]
    puts "Insufficient funds!"
    false
  else
    account[:balance] -= amount
    true
  end
end

def transfer(accounts, from_account)
  print "Enter the recipient account number: "
  to_account_number = gets.chomp
  to_account = accounts[to_account_number]

  if to_account.nil?
    puts "Recipient account not found!"
    return
  end

  print "Enter the amount to transfer: "
  amount = gets.chomp.to_f

  if withdraw(from_account, amount)
    deposit(to_account, amount)
    puts "Transfer successful! New balance: $#{from_account[:balance]}"
  end
end

def check_balance(account)
  puts "Account Number: #{account[:account_number]}"
  puts "Account Holder: #{account[:first_name]}"
  puts "Current Balance: $#{account[:balance]}"
end

def main_menu(accounts, usernames)
  loop do
    puts "\nWelcome to the Bank Management System"
    puts "1. Register"
    puts "2. Login"
    puts "3. Exit"
    print "Please choose an option: "
    choice = gets.chomp.to_i

    case choice
    when 1
      register(accounts, usernames)
    when 2
      account = login(accounts, usernames)
      user_menu(accounts, account) if account
    when 3
      puts "Thank you for using the Bank Management System!"
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

def user_menu(accounts, account)
  loop do
    puts "\nAccount Menu"
    puts "1. Deposit"
    puts "2. Withdraw"
    puts "3. Transfer"
    puts "4. Check Balance"
    puts "5. Logout"
    print "Please choose an option: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Enter amount to deposit: "
      amount = gets.chomp.to_f
      deposit(account, amount)
      puts "Deposit successful! New balance: $#{account[:balance]}"
    when 2
      print "Enter amount to withdraw: "
      amount = gets.chomp.to_f
      if withdraw(account, amount)
        puts "Withdrawal successful! New balance: $#{account[:balance]}"
      end
    when 3
      transfer(accounts, account)
    when 4
      check_balance(account)
    when 5
      puts "Logged out successfully!"
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

# Initialize accounts and usernames
accounts = {
  "00000000000001" => {
    first_name: "Alice",
    age: 30,
    pin: "1234",
    balance: 1000.0,
    username: "alice123"
  },
  "00000000000002" => {
    first_name: "Bob",
    age: 25,
    pin: "5678",
    balance: 1500.0,
    username: "bob567"
  }
}

usernames = {
  "alice123" => "00000000000001",
  "bob567" => "00000000000002"
}

main_menu(accounts, usernames)
