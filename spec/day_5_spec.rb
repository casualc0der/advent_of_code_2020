require_relative '../day_5/day_5'
require 'tempfile'
RSpec.describe 'Binary Boarding' do
  describe 'setup' do
    let(:test_data) { <<~DATA
                         BFFFBBFRRR
                         FFFBBBFRRR
                         BBFFBBFRLL
                         DATA
}
    it 'can open the file and read the data' do
      file = Tempfile.new
      file.write('hello')
      file.flush
      ticket_scanner = TicketScanner.new(file)
      expect(ticket_scanner.data).not_to be_empty
    end
    it 'can format the data into lines' do
      file = Tempfile.new
      file.write(test_data)
      file.flush
      ticket_scanner = TicketScanner.new(file)
      expected = [
                         'BFFFBBFRRR',
                         'FFFBBBFRRR',
                         'BBFFBBFRLL'
                 ]
      expect(ticket_scanner.data).to eq(expected)
    end
  end
  describe 'part 1' do
    context '#seat_splitter' do
      it 'can correcly divide the rows based on the supplied letter' do
        file = Tempfile.new
        file.write('hello')
        file.flush
        ticket_scanner = TicketScanner.new(file)
        low_rows = (0..31).to_a
        expected_lower_half = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        expected_upper_half = [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
        expect(ticket_scanner.seat_splitter('F', low_rows)).to eq(expected_lower_half)
        expect(ticket_scanner.seat_splitter('B', low_rows)).to eq(expected_upper_half)
        expect(ticket_scanner.seat_splitter('L', low_rows)).to eq(expected_lower_half)
        expect(ticket_scanner.seat_splitter('R', low_rows)).to eq(expected_upper_half)
      end
      it 'can correctly split a 2 element array' do
        file = Tempfile.new
        file.write('hello')
        file.flush
        ticket_scanner = TicketScanner.new(file)
        low_rows = (0..1).to_a
        expected_lower_half = [0]
        expected_upper_half = [1]
        expect(ticket_scanner.seat_splitter('F', low_rows)).to eq(expected_lower_half)
        expect(ticket_scanner.seat_splitter('B', low_rows)).to eq(expected_upper_half)
        expect(ticket_scanner.seat_splitter('L', low_rows)).to eq(expected_lower_half)
        expect(ticket_scanner.seat_splitter('R', low_rows)).to eq(expected_upper_half)
      end
    end

    context '#seat_finder' do
      it 'can find a seat based on the supplied string' do
        file = Tempfile.new
        file.write('FBFBBFFRLR')
        file.flush
        str = 'FBFBBFFRLR'
        ticket_scanner = TicketScanner.new(file)
        expect(ticket_scanner.seat_finder(str)).to eq(357)
      end
      it 'can find multiple seats based on supplied strings' do
        file = Tempfile.new
        file.write('FBFBBFFRLR')
        file.flush
        test_data_1 = 'BFFFBBFRRR'
        test_data_2 = 'FFFBBBFRRR'
        test_data_3 = 'BBFFBBFRLL'
        ticket_scanner = TicketScanner.new(file)
        expect(ticket_scanner.seat_finder(test_data_1)).to eq(567)
        expect(ticket_scanner.seat_finder(test_data_2)).to eq(119)
        expect(ticket_scanner.seat_finder(test_data_3)).to eq(820)
      end
    end
    context '#largest_seat_id' do
      let(:test_data) { <<~DATA
                           BFFFBBFRRR
                           FFFBBBFRRR
                           BBFFBBFRLL
                           DATA
}
      it 'finds the largest seat ID from the list (smol)' do
        file = Tempfile.new
        file.write(test_data)
        file.flush
        ticket_scanner = TicketScanner.new(file)
        expect(ticket_scanner.largest_seat_id).to eq(820)
      end
      it 'finds the largest seat ID from the list (full)' do
        path = File.expand_path(File.dirname(__FILE__) + "/plane_tickets.txt")
        ticket_scanner = TicketScanner.new(path)
        expect(ticket_scanner.largest_seat_id).to eq(976)
      end
    end
  end
  describe 'part 2' do
    context '#my_seat' do
      it 'can find my seat' do
        path = File.expand_path(File.dirname(__FILE__) + "/plane_tickets.txt")
        ticket_scanner = TicketScanner.new(path)
        expect(ticket_scanner.my_seat).to eq(685)
      end
    end
  end
end
