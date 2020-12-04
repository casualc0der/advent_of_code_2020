module Validator

  def birth_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 1920
    return false if field.to_i > 2002
    true
  end
  def issue_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 2010
    return false if field.to_i > 2020
    true
  end
  def expiration_year_valid?(field)
    return false unless field.size == 4
    return false if field.to_i < 2020
    return false if field.to_i > 2030
    true
  end
  def height_valid?(field)
    return false unless field.include?('cm') || field.include?('in')
    if field.include?('cm')
      height = field.split('cm').first.to_i
      return false if height < 150
      return false if height > 193
    else
      height = field.split('in').first.to_i
      return false if height < 59
      return false if height > 76
    end
    true
  end

  def hair_colour_valid?(field)
    return false unless field[0] == '#'
    return false if field.size > 7
    allowed_chars = (0..9).to_a.map(&:to_s) + ('a'..'f').to_a
    allowed_chars << '#'
    return false if (field.split('') - allowed_chars).size > 0
    true
  end

  def eye_colour_valid?(field)
    allowed_eye_colours = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
    return false unless allowed_eye_colours.include?(field)
    true
  end

  def passport_id_valid?(field)
    allowed_chars = (0..9).to_a.map(&:to_s)
    return false unless field.size == 9
    return false if (field.split('') - allowed_chars).size > 0
    true
  end
end
