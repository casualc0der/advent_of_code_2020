class CustomsForm
  attr_reader :data
  def initialize(file)
    @data = File.read(file).chomp.split("\n\n")
  end
  def sanitized_data
    data.map {|group| group.tr("\n", '') }
  end
  def sanitized_group_data
    data.map {|group| group.split("\n").map{|person| [person]} }
  end
  def questions_answered
    sanitized_data.map {|group| group.split('').uniq.size }.sum
  end
  def collective_questions_answered
    sanitized_group_data.map {|group| checker(group)}.sum
  end

  def checker(arr)
    return arr.inject(&:&).first.size if arr.size == 1
    arr.map {|group| group.first.split('')}.inject(&:&).size
    end
  end

