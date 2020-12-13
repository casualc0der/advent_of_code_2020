require 'set'
require 'pry'
class BagSorter
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n")
    @bags = Set.new
  end
  def sanitized_data
    data.map {|bags| sanitizer(bags) }
  end

  # what a God awful mess
  def sanitizer(str)
    arr = str.split(' contain ')
       .map{|x| x.gsub(/bags/, '')
       .gsub(/bag/, '')
       .tr('.', '')}

    if arr[1] == 'no other '
      contains = []
    else
    contains = arr[1].strip.split(' , ').map{|bag|
      new_bag = bag.split(' ')
      {'name' => new_bag[1] + ' ' + new_bag[2], 'qty' => new_bag[0].to_i }}
    end
    {'name' => arr[0].strip, 'contains' => contains}
  end

  # we are close, but we need a way to check all of the edges ABOVE the shiny gold bag
  def find_all_bags(part = :part1)
    graph = Graph.new
    sanitized_data.each do |bag|
      graph.vertices << Vertex.new(bag['name'])
    end

    graph.vertices.each do |v|
      contains = sanitized_data.select {|bag| bag['name'] == v.name}.first
      contains['contains'].each do |edge|
        g = graph.select_vertex(edge['name'])
        v.contains << {name: edge['name'], qty: edge['qty'] }
        v.add_edge(g)
        g.add_parent(v)
      end
    end

    case part
    when :part1
    wap = graph.vertices.select {|v| v.name == 'shiny gold'}

    parents = Set.new
    while wap.size > 0
      temp = []
      wap.each do |v|
        parents << v.name
        v.parent.each {|bag| temp << bag}
      end
      wap = temp
    end

    return (parents.size) - 1

    when :part2

    wap = graph.vertices.select {|v| v.name == 'shiny gold'}

    contents = []
    while wap.size > 0
      temp = []
      wap.each do |v|
        binding.pry
        v.edges.each {|bag| temp << bag}
      end
      wap = temp
    end

    return contents
    end



end

  def bag_adder(bag)
    return bag if bag.contains.sum == 0

    bag_adder(bag.edges.first)
  end


end


class Graph
  attr_accessor :vertices
  def initialize
    @vertices = Set.new
  end
  def find_vertex?(name)
    @vertices.any? {|v| v.name == name}
  end
  def select_vertex(name)
    @vertices.select {|obj| obj.name == name}.first
  end
  def add_vertex(vertex)
    @vertices << vertex
  end

end

class Vertex
  attr_reader :name, :edges, :parent
  attr_accessor :contains
  def initialize(name)
    @name = name
    @edges = []
    @parent = []
    @contains = []
  end

  def add_edge(vertex)
    @edges << vertex
  end
  def find_edges(name)
    @edges.select {|v| v.name == name}
  end
  def add_parent(vertex)
    @parent << vertex
  end
end





require 'tempfile'
RSpec.describe 'Handy Haversacks' do
  let(:test_data) { <<~FILE
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
}

  let(:test_data_2) { <<~FILE
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
                       FILE
}

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
        {'name' => 'light red', 'contains' => [
          {'name' => 'bright white', 'qty' => 1},
          {'name' => 'muted yellow', 'qty' => 2}]}

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
        {'name' => 'light red', 'contains' =>
         [
          {'name' => 'bright white', 'qty' => 1},
          {'name' => 'muted yellow', 'qty' => 2}
         ],
        },
        {'name' => 'dotted black', 'contains' => [] }
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
        {'name' => 'light red', 'contains' =>
         [
          {'name' => 'bright white', 'qty' => 1},
          {'name' => 'muted yellow', 'qty' => 2}
         ],
        },
        {'name' => 'dark orange', 'contains' =>
         [
         {'name' => 'bright white', 'qty' => 3},
         {'name' => 'muted yellow', 'qty' => 4}
          ]
         },
        {'name' => 'dotted black', 'contains' => [] }
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
      path = File.expand_path(File.dirname(__FILE__) + "/bags.txt")
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
#   it 'can return the correct amount of holding bags full list' do
#     pending 'dont run'
#     path = File.expand_path(File.dirname(__FILE__) + "/bags.txt")
#     bag_sorter = BagSorter.new(path)
#     expect(bag_sorter.find_all_bags(:part2)).to eq(12)
#   end
 end
=begin 
 describe '#bag_adder' do
   it 'can return the correct amount of bags' do
    file = Tempfile.new
     file.write('test')
     file.flush
     bag_sorter = BagSorter.new(file)
     data = [[1, 2], [3, 4], [5, 6], [], [], [], []]


     expect(bag_sorter.bag_adder(data)).to eq(32)

   end

 end
=end
  end
