class BagSorter
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n")
  end
end

# For this problem i think we should employ some form of duck typing OO
# E.g lets make a bag class, with @contains.
# We can store other bag objects within the @contains instance variable (array)
# and then we can recursively find the correct bag from within the bag sorter


require 'tempfile'
RSpec.describe 'Handy Haversacks' do
  let(:test_data) { <<~FILE
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
  end
end
