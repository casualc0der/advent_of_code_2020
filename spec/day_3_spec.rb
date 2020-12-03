class Trajectory
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n")
  end

  def pattern
    @data.map {|x| x * 100}
  end

  def parse
    trees = 0
    current_index = 0
    pattern.each do |move|
      trees += 1 if move[current_index] == '#'
      current_index += 3
    end
    trees
  end


end


require 'tempfile'
RSpec.describe 'Toboggan Trajectory' do
  it 'can open the file to be read' do
    file = Tempfile.new
    file.write('test')
    file.flush
    trajectory = Trajectory.new(file)
    expect(trajectory.data).not_to be_empty
  end

  it 'can split the input into chunks' do
    file = Tempfile.new
    file.write(<<~ROUTE
               ....#............#.###...#.#.#.
               .#.#....##.........#.....##.#..
               ROUTE
              )
    file.flush
    trajectory = Trajectory.new(file)
    expect(trajectory.data).to eq(['....#............#.###...#.#.#.', '.#.#....##.........#.....##.#..'])
  end

  it 'can create a pattern string' do
    file = Tempfile.new
    file.write(<<~ROUTE
               ....#............#.###...#.#.#.
               .#.#....##.........#.....##.#..
               ROUTE
              )
    file.flush
    trajectory = Trajectory.new(file)
    expect(trajectory.pattern).to eq(['....#............#.###...#.#.#.' *100, '.#.#....##.........#.....##.#..'*100])
  end

  it 'can find trees in a simple pattern' do
    file = Tempfile.new
    file.write(<<~ROUTE
                ..##.........##.........##.........##.........##.........##.......
                #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
                .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
                ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
                .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
                ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
                .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
                .#........#.#........#.#........#.#........#.#........#.#........#
                #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
                #...##....##...##....##...##....##...##....##...##....##...##....#
                .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#
                ROUTE
              )
    file.flush
    trajectory = Trajectory.new(file)
    expect(trajectory.parse).to eq(7)
  end

  it 'can find trees in the full pattern' do
    path = File.expand_path(File.dirname(__FILE__) + "/route_planner.txt")
    trajectory = Trajectory.new(path)
    expect(trajectory.parse).to eq('?')
  end
end
