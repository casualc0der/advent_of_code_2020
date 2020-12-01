class Report
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i)
  end
  def parse(num_of_entries)
      @data.permutation(num_of_entries)
           .select {|x| x.sum == 2020}
           .map(&:sort)
           .uniq
           .flatten(1)
           .inject(:*)
  end
end

require 'tempfile'
RSpec.describe 'Report Repair' do
  let(:file)   { Tempfile.new }

  it 'can open a file and read contents to array' do
    file.write(<<~FILE
               1000
               1020
               FILE
              )
    file.flush
    report = Report.new(file)
    expect(report.data).to eq([1000, 1020])
  end
  it 'can find 2 elements that equal 2020' do
    path = File.expand_path(File.dirname(__FILE__) + "/expense_report.txt")
    report = Report.new(path)
    expect(report.parse(2)).to eq(858496)
  end
  it 'can find 3 elements that equal 2020' do
    path = File.expand_path(File.dirname(__FILE__) + "/expense_report.txt")
    report = Report.new(path)
    expect(report.parse(3)).to eq(263819430)
  end
end
