class Trajectory
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n")
  end

  def pattern
    @data.map {|x| x * 75}
  end

  def single_journey(right=3, down=1)
    trees_hit = 0
    current_index = 0
    pattern.each_with_index do |move, i|
      next if skip_row?(i, down)
      trees_hit += 1 if hit_a_tree?(move[current_index])
      current_index += right
    end
    trees_hit
  end

  def multi_journey(routes)
    routes.map { |route| single_journey(route[0], route[1]) }.inject(:*)
  end

  private

  def hit_a_tree?(pos)
    pos == '#'
  end

  def skip_row?(index, down)
    index % 2 != 0 && down == 2
  end

end
