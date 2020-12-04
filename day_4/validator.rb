module Validator

  def strict_validate(passport)
      return false unless birth_year_valid?(passport['byr'])
      return false unless issue_year_valid?(passport['iyr'])
      return false unless expiration_year_valid?(passport['eyr'])
      return false unless height_valid?(passport['hgt'])
      return false unless hair_colour_valid?(passport['hcl'])
      return false unless eye_colour_valid?(passport['ecl'])
      return false unless passport_id_valid?(passport['pid'])
      true
  end

  def birth_year_valid?(field)
    return false unless (1920..2002).include?(field.to_i)
    true
  end
  def issue_year_valid?(field)
    return false unless (2010..2020).include?(field.to_i)
    true
  end
  def expiration_year_valid?(field)
    return false unless (2020..2030).include?(field.to_i)
    true
  end
  def height_valid?(field)
    return false unless field.include?('cm') || field.include?('in')
    if field.include?('cm')
      height = field.split('cm').first.to_i
      return false unless (150..193).include?(height)
    else
      height = field.split('in').first.to_i
      return false unless (59..76).include?(height)
    end
    true
  end

  def hair_colour_valid?(field)
    return false unless field[0] == '#'
    allowed_chars = (0..9).to_a.map(&:to_s) + ('a'..'f').to_a << '#'
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
