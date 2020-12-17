# frozen_string_literal: true

require_relative '../day_2/day_2'
require 'tempfile'
RSpec.describe 'Password Philosophy' do
  it 'can open and read the file' do
    file = Tempfile.new
    file.write(<<~PASSWORDS
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

    file.write(<<~PASSWORDS
      3-5 f: fgfff
    PASSWORDS
              )
    file.flush
    password_checker = PasswordChecker.new(file)
    expected = [
      { min: 3, max: 5, letter: 'f', password: 'fgfff' }
    ]
    expect(password_checker.format).to eq(expected)
  end
  it 'can format multiple lines' do
    file = Tempfile.new
    file.write(<<~PASSWORDS
      3-5 f: fgfff
      6-20 n: qlzsnnnndwnlhwnxhvjn
      6-7 j: jjjjjwrj
    PASSWORDS
              )
    file.flush

    password_checker = PasswordChecker.new(file)

    expected = [
      { min: 3, max: 5, letter: 'f', password: 'fgfff' },
      { min: 6, max: 20, letter: 'n', password: 'qlzsnnnndwnlhwnxhvjn' },
      { min: 6, max: 7, letter: 'j', password: 'jjjjjwrj' }
    ]
    expect(password_checker.format).to eq(expected)
  end

  it 'can check how many valid passwords there are (smol list)' do
    file = Tempfile.new
    file.write(<<~PASSWORDS
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
    path = File.expand_path("#{File.dirname(__FILE__)}/password_report.txt")
    password_checker = PasswordChecker.new(path)
    expect(password_checker.check).to eq(564)
  end

  context 'part 2 of the challenge' do
    it 'can check how many valid passwords there are (smol list)' do
      file = Tempfile.new
      file.write(<<~PASSWORDS
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
      path = File.expand_path("#{File.dirname(__FILE__)}/password_report.txt")
      password_checker = PasswordChecker.new(path)
      expect(password_checker.check(:part_2)).to eq(325)
    end
  end
end
