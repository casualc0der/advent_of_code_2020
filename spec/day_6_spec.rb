require_relative '../day_6/day_6'
require 'tempfile'
RSpec.describe 'Custom Customs' do
  let(:test_data) {<<~FILE
                   abc

                   a
                   b
                   c

                   ab
                   ac

                   a
                   a
                   a
                   a

                   b
                      FILE

  }
  describe 'setup' do
    it 'can open a file to be read' do
      file = Tempfile.new
      file.write('hello')
      file.flush
      customs_form = CustomsForm.new(file)
      expect(customs_form.data).not_to be_empty
    end
    it 'can cluster the forms by distinct groups' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      customs_form = CustomsForm.new(file)
      expected = [
     "abc", "a\nb\nc", "ab\nac", "a\na\na\na", "b"
      ]
      expect(customs_form.data).to eq(expected)
    end
    it 'can remove the pesky whitespace from each group' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      customs_form = CustomsForm.new(file)
      expected = [
     "abc", "abc", "abac", "aaaa", "b"
      ]
      expect(customs_form.sanitized_data).to eq(expected)
    end
    it 'can split each group into a distinct array' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      customs_form = CustomsForm.new(file)
      expected = [
                 [ [ 'abc' ] ],
                 [ [ 'a' ], [ 'b' ], [ 'c' ] ],
                 [ [ 'ab' ], [ 'ac' ] ],
                 [ [ 'a' ], [ 'a' ], [ 'a' ], [ 'a' ] ],
                 [ [ 'b' ] ]
                 # megaray.inject(&:&)
      ]
      expect(customs_form.sanitized_group_data).to eq(expected)
    end
  end
  describe 'part 1' do
    context '#questions_answered' do
      it 'can tally the amount of questions answered per group and return total (smol list)' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      customs_form = CustomsForm.new(file)
      expect(customs_form.questions_answered).to eq(11)
      end
      it 'can tally the amount of questions answered per group and return total (full list)' do
      path = File.expand_path(File.dirname(__FILE__) + "/customs_decs.txt")
      customs_form = CustomsForm.new(path)
      expect(customs_form.questions_answered).to eq(6809)
      end
    end
  end
    describe 'part 2' do
      context '#collective_questions_answered' do
        it 'can tally the amount of shared questions answered per group and return total (smol list)' do
        file = Tempfile.new
        file.write(test_data)
        file.flush
        customs_form = CustomsForm.new(file)
        expect(customs_form.collective_questions_answered).to eq(6)
        end
      it 'can tally the amount of questions answered per group and return total (full list)' do
      path = File.expand_path(File.dirname(__FILE__) + "/customs_decs.txt")
      customs_form = CustomsForm.new(path)
      expect(customs_form.collective_questions_answered).to eq(3394)
      end
      end
      context '#checker' do
        it 'can correctly check the differences between arrays' do
        file = Tempfile.new
        file.write('hello')
        file.flush
        customs_form = CustomsForm.new(file)
        expect(customs_form.checker([['abc']])).to eq(3)
        expect(customs_form.checker([ [ 'a' ], [ 'b' ], [ 'c' ] ])).to eq(0)
        expect(customs_form.checker([ [ 'ab' ], [ 'ac' ] ])).to eq(1)
        expect(customs_form.checker([ ['b'] ])).to eq(1)
        end

        end
      end
  end
