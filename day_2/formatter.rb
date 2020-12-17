# frozen_string_literal: true

module Formatter
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
