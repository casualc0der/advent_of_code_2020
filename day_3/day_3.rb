class Trajectory
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n")
  end

  def pattern
    @data.map {|x| x * 75}
  end

  def single_journey(right=3, down=1)
    trees = 0
    current_index = 0
    pattern.each_with_index do |move, i|
      next if i % 2 != 0 && down == 2
      trees += 1 if move[current_index] == '#'
      current_index += right
    end
    trees
  end

  def multi_journey(routes)
    trees = []
    routes.each do |route|
    trees << single_journey(route[0], route[1])
    end
    trees.inject(:*)
  end
end
