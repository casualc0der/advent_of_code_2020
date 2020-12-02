class PasswordChecker
  include Validator
  attr_reader :data
  def initialize(file)
    @data = File.open(file).read.split("\n")
  end
  def check(flag = :part_1)
    data = format
    data.map {|password_line| password_validator(password_line, flag) }.sum
  end

  def format
    @data.map do |line|
      format_line(line)
    end
  end

  private


    def format_line(line)

      data_line = line.split(/ /)
      min_max = data_line[0].split('-')
      letter_to_check = data_line[1].gsub(':', '')
      password_to_check = data_line[2]

     {
       min: min_max.first.to_i,
       max: min_max.last.to_i,
       letter: letter_to_check,
       password: password_to_check
      }
    end
  end


  module Validator
  def password_validator(password_line, flag)
    case flag
    when :part_1
     num =  password_line[:password].split('').tally[password_line[:letter]] || 0
     return num >= password_line[:min] && num <= password_line[:max] ? 1 : 0
    when :part_2
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


require 'tempfile'
RSpec.describe 'Password Philosophy' do

  it 'can open and read the file' do
    file = Tempfile.new
    file.write( <<~PASSWORDS
    3-5 f: fgfff
    6-20 n: qlzsnnnndwnlhwnxhvjn
    6-7 j: jjjjjwrj
    PASSWORDS
              )
    file.flush

    password_checker = PasswordChecker.new(file)
    expect(password_checker.data).not_to be_empty
  end

  it 'can format a line' do
    file = Tempfile.new

    file.write( <<~PASSWORDS
    3-5 f: fgfff
    PASSWORDS
              )
    file.flush
    password_checker = PasswordChecker.new(file)
    expected = [
      {min: 3, max:5, letter: 'f', password: 'fgfff'}
    ]
    expect(password_checker.format).to eq(expected)
  end
  it 'can format multiple lines' do

    file = Tempfile.new
    file.write( <<~PASSWORDS
    3-5 f: fgfff
    6-20 n: qlzsnnnndwnlhwnxhvjn
    6-7 j: jjjjjwrj
    PASSWORDS
              )
    file.flush

    password_checker = PasswordChecker.new(file)

    expected = [
      {min: 3, max:5, letter: 'f', password: 'fgfff'},
      {min: 6, max: 20, letter: 'n', password: 'qlzsnnnndwnlhwnxhvjn'},
      {min: 6, max: 7, letter: 'j', password: 'jjjjjwrj'}
    ]
    expect(password_checker.format).to eq(expected)
  end

  it 'can check how many valid passwords there are (smol list)' do

    file = Tempfile.new
    file.write( <<~PASSWORDS
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    PASSWORDS
              )
    file.flush

    password_checker = PasswordChecker.new(file)

    expect(password_checker.check).to eq(2)
  end

  it 'can check how many valid passwords there are (full list)' do
    path = File.expand_path(File.dirname(__FILE__) + "/password_report.txt")
    password_checker = PasswordChecker.new(path)
    expect(password_checker.check).to eq(564)
  end

  context 'part 2 of the challenge' do
    it 'can check how many valid passwords there are (smol list)' do

    file = Tempfile.new
    file.write( <<~PASSWORDS
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    PASSWORDS
              )
    file.flush

    password_checker = PasswordChecker.new(file)

    expect(password_checker.check(:part_2)).to eq(1)
    end

  it 'can check how many valid passwords there are (full list)' do
    path = File.expand_path(File.dirname(__FILE__) + "/password_report.txt")
    password_checker = PasswordChecker.new(path)
    expect(password_checker.check(:part_2)).to eq(325)
  end
  end
end
