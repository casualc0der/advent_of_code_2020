require_relative '../day_5/day_5'
require 'tempfile'
RSpec.describe 'Binary Boarding' do
  describe 'part 1' do

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
