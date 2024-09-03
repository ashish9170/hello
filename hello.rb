require 'securerandom'

def generate_account_number
  SecureRandom.random_number(10**14).to_s.rjust(14, '0')
end

def register(accounts)
  print "Enter your first name: "
  first_name = gets.chomp
  print "Enter your age: "
  age = gets.chomp.to_i
  print "Enter your PIN: "
  pin = gets.chomp

  account_number = generate_account_number
  accounts[account_number] = {
    first_name: first_name,
    age: age,
    pin: pin,
    balance: 0.0,
    transactions: []
  }

  puts "Registration successful! Your account number is #{account_number}."
end

def login(accounts)
  print "Enter your account number: "
  account_number = gets.chomp
  print "Enter your PIN: "
  pin = gets.chomp

  account = accounts[account_number]
  if account && account[:pin] == pin
    puts "Login successful!"
    account[:account_number] = account_number  # Include account number in account hash
    account
  else
    puts "Invalid account number or PIN."
    nil
  end
end

def deposit(account, amount)
  account[:balance] += amount
  account[:transactions] << { type: "Deposit", amount: amount, date: Time.now }
end

def withdraw(account, amount)
  if amount > account[:balance]
    puts "Insufficient funds!"
    false
  else
    account[:balance] -= amount
    account[:transactions] << { type: "Withdrawal", amount: amount, date: Time.now }
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
    from_account[:transactions] << { type: "Transfer to #{to_account_number}", amount: amount, date: Time.now }
    to_account[:transactions] << { type: "Transfer from #{from_account[:account_number]}", amount: amount, date: Time.now }
    puts "Transfer successful! New balance: $#{from_account[:balance]}"
  end
end

def check_balance(account)
  puts "Account Number: #{account[:account_number]}"
  puts "Account Holder: #{account[:first_name]}"
  puts "Current Balance: $#{account[:balance]}"
end

def view_transactions(account)
  puts "Transaction History for Account #{account[:account_number]}:"
  account[:transactions].each do |transaction|
    puts "#{transaction[:type]} of $#{transaction[:amount]} on #{transaction[:date]}"
  end
end

def main_menu(accounts)
  loop do
    puts "\nWelcome to the Bank Management System"
    puts "1. Register"
    puts "2. Login"
    puts "3. Exit"
    print "Please choose an option: "
    choice = gets.chomp.to_i

    case choice
    when 1
      register(accounts)
    when 2
      account = login(accounts)
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
    puts "5. View Transactions"
    puts "6. Logout"
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
      view_transactions(account)
    when 6
      puts "Logged out successfully!"
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end
