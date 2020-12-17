class Adapter
  attr_reader :data
  def initialize(file)
    @data = File.read(file).split("\n").map(&:to_i)
  end
end


require 'tempfile'

RSpec.describe Adapter do
  subject { Adapter.new(file) }

    let(:file) { Tempfile.new }
    let(:input) { <<~FILE
                      1
                      2
                      3
                      4
                      5
                     FILE
                }

    context 'it creates an array containing the data' do
      before do
        file.write(input)
        file.flush
      end
      it { expect(subject.data).not_to be_empty }
      it { expect(subject.data).to eq([1,2,3,4,5]) }
    end
  end
