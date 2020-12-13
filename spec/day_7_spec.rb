require_relative '../day_7/day_7'
require 'tempfile'
RSpec.describe 'Handy Haversacks' do
  let(:test_data) do
    <<~FILE
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
    FILE
  end

  let(:test_data_2) do
    <<~FILE
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
    FILE
  end

  describe 'setup' do
    it 'can open the file to be read' do
      file = Tempfile.new
      file.write('hello')
      file.flush
      bag_sorter = BagSorter.new(file)
      expect(bag_sorter.data).not_to be_empty
    end
    it 'can split the data correctly 1 row' do
      file = Tempfile.new
      file.write('light red bags contain 1 bright white bag, 2 muted yellow bags.')
      file.flush
      bag_sorter = BagSorter.new(file)

      expected = [
        { 'name' => 'light red', 'contains' => [
          { 'name' => 'bright white', 'qty' => 1 },
          { 'name' => 'muted yellow', 'qty' => 2 }
        ] }

      ]
      expect(bag_sorter.sanitized_data).to eq(expected)
    end
    it 'can split the data correctly 2 rows' do
      file = Tempfile.new

      file.write(<<~FILE
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dotted black bags contain no other bags.
      FILE
                )
      file.flush
      bag_sorter = BagSorter.new(file)
      expected = [
        { 'name' => 'light red', 'contains' =>
         [
           { 'name' => 'bright white', 'qty' => 1 },
           { 'name' => 'muted yellow', 'qty' => 2 }
         ] },
        { 'name' => 'dotted black', 'contains' => [] }
      ]
      expect(bag_sorter.sanitized_data).to eq(expected)
    end
    it 'can split the data correctly 3 rows' do
      file = Tempfile.new

      file.write(<<~FILE
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        dotted black bags contain no other bags.
      FILE
                )
      file.flush
      bag_sorter = BagSorter.new(file)
      expected = [
        { 'name' => 'light red', 'contains' =>
         [
           { 'name' => 'bright white', 'qty' => 1 },
           { 'name' => 'muted yellow', 'qty' => 2 }
         ] },
        { 'name' => 'dark orange', 'contains' =>
         [
           { 'name' => 'bright white', 'qty' => 3 },
           { 'name' => 'muted yellow', 'qty' => 4 }
         ] },
        { 'name' => 'dotted black', 'contains' => [] }
      ]
      expect(bag_sorter.sanitized_data).to eq(expected)
    end
  end
  describe '#find_all_bags part1' do
    it 'can return the correct amount of holding bags smol list' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      bag_sorter = BagSorter.new(file)
      expect(bag_sorter.find_all_bags).to eq(4)
    end
    it 'can return the correct amount of holding bags full list' do
      path = File.expand_path("#{File.dirname(__FILE__)}/bags.txt")
      bag_sorter = BagSorter.new(path)
      expect(bag_sorter.find_all_bags).to eq(300)
    end
  end

  describe '#find_all_bags part2' do
    it 'can return the correct amount of holding bags smol list' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      bag_sorter = BagSorter.new(file)
      expect(bag_sorter.find_all_bags(:part2)).to eq(32)
    end

    it 'can return the correct amount of holding bags med list' do
      file = Tempfile.new
      file.write(test_data_2)
      file.flush

      bag_sorter = BagSorter.new(file)
      expect(bag_sorter.find_all_bags(:part2)).to eq(126)
    end
    it 'can return the correct amount of holding bags full list' do
      path = File.expand_path("#{File.dirname(__FILE__)}/bags.txt")
      bag_sorter = BagSorter.new(path)
      expect(bag_sorter.find_all_bags(:part2)).to eq(8030)
    end
  end
end
