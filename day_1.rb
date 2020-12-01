class Report
  attr_reader :data

  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i)
  end

  # very slow, but easy to implement ;)
  def parse(entries_to_sum)
    @data.permutation(entries_to_sum)
         .select {|x| x.sum == 2020}
         .map(&:sort)
         .uniq
         .flatten(1)
         .inject(:*)
  end
end
