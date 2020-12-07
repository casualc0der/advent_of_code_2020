class BagSorter
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n")
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

  def find_root_bags
    sanitized_data.select {|bag| bag["contains"].empty? }
  end

end

# For this problem i think we should employ some form of duck typing OO
# E.g lets make a bag class, with @contains.
# We can store other bag objects within the @contains instance variable (array)
# and then we can recursively find the correct bag from within the bag sorter
#
# class Bag
#   def initialize(name)
#   @name = name
#   @contains = []
#   end
# end


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
  describe '#find_root_bags' do
    it 'can find all bags that contain no bags' do
      file = Tempfile.new
      file.write(test_data)
      file.flush

      bag_sorter = BagSorter.new(file)
      expected = [
        {'name' => 'dotted black', 'contains' => [] },
        {'name' => 'faded blue', 'contains' => [] },
      ]
      expect(bag_sorter.find_root_bags)

    end
  end
end
