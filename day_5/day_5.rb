class TicketScanner
  attr_reader :data, :seat_locations

  SEAT_ID_MODIFIER = 8
  ALL_POSSIBLE_TICKETS = (8..976).to_a

  def initialize(file)
    @data = File.read(file).split(/\n/)
    @seat_locations = @data.map {|ticket| seat_finder(ticket)}
  end

  def largest_seat_id
    seat_locations.max
  end

  def my_seat
    (ALL_POSSIBLE_TICKETS - seat_locations).first
  end

  def seat_finder(str)
    plane_rows = (0..127).to_a
    plane_cols= (0..7).to_a
    rows = str[0...7].split(//)
    cols = str[7..str.size].split(//)

    plane_rows = seat_splitter(rows.shift, plane_rows) while plane_rows.size > 1
    plane_cols = seat_splitter(cols.shift, plane_cols) while plane_cols.size > 1

    return plane_rows.first * SEAT_ID_MODIFIER + plane_cols.first
  end

  def seat_splitter(char, arr, pivot = arr.size/2)
    return arr[0...pivot] if char == 'F' || char == 'L'
    arr[pivot..arr.size]
  end
end

