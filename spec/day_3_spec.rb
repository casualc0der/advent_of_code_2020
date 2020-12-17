# frozen_string_literal: true

require_relative '../day_3/day_3'
require 'tempfile'

RSpec.describe 'Toboggan Trajectory' do
  let(:test_route) do
    <<~ROUTE
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
  end
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
    expect(trajectory.pattern).to eq(['....#............#.###...#.#.#.' * 75, '.#.#....##.........#.....##.#..' * 75])
  end

  context 'Part 1' do
    it 'can find trees in a simple pattern' do
      file = Tempfile.new
      file.write(test_route)
      file.flush
      trajectory = Trajectory.new(file)
      expect(trajectory.single_journey).to eq(7)
    end

    it 'can find trees in the full pattern' do
      path = File.expand_path("#{File.dirname(__FILE__)}/route_planner.txt")
      trajectory = Trajectory.new(path)
      expect(trajectory.single_journey).to eq(169)
    end
  end

  context 'Part 2' do
    it 'can change the simple route' do
      file = Tempfile.new
      file.write(test_route)
      file.flush
      trajectory = Trajectory.new(file)
      expect(trajectory.single_journey(1, 1)).to eq(2)
      expect(trajectory.single_journey(3, 1)).to eq(7)
      expect(trajectory.single_journey(5, 1)).to eq(3)
      expect(trajectory.single_journey(7, 1)).to eq(4)
      expect(trajectory.single_journey(1, 2)).to eq(2)
    end

    it 'can multiply all of the returned values together (simple)' do
      file = Tempfile.new
      file.write(test_route)
      file.flush
      trajectory = Trajectory.new(file)
      journeys = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
      expect(trajectory.multi_journey(journeys)).to eq(336)
    end

    it 'can multiply all of the returned values together (full)' do
      path = File.expand_path("#{File.dirname(__FILE__)}/route_planner.txt")
      trajectory = Trajectory.new(path)
      journeys = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
      expect(trajectory.multi_journey(journeys)).to eq(7_560_370_818)
    end
  end
end
