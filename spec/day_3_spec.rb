class Trajectory
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n")
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
end
