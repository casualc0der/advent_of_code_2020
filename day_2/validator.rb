  module Validator
  def password_validator(password_line, flag)
    case flag
    when :part_1
      # Tally number of letters in the password and ensure it is between min/max
     num =  password_line[:password].split('').tally[password_line[:letter]] || 0
     return num >= password_line[:min] && num <= password_line[:max] ? 1 : 0
    when :part_2
      # Check postions of the letters as validation
      first_index = password_line[:min]
      second_index = password_line[:max]
      password = password_line[:password].split('').unshift(0)
      letter = password_line[:letter]

      return 0 if password[first_index] == letter && password[second_index] == letter
      return 1 if password[first_index] == letter || password[second_index] == letter
      0
    end
  end
  end
