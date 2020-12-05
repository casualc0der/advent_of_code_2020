class TicketScanner
  attr_reader :data

  SEAT_ID_MODIFIER = 8

  def initialize(file)
    @data = File.read(file).split("\n")
  end

  def largest_seat_id
    @data.map {|ticket| seat_finder(ticket)}.max
  end

  def my_seat
    seen_tickets = @data.map {|ticket| seat_finder(ticket)}
    all_possible_tickets = (8..976).to_a
    (all_possible_tickets - seen_tickets).first
  end

  def seat_finder(str)
    plane_rows = (0..127).to_a
    plane_columns = (0..7).to_a
    rows_on_ticket = str[0...7].split(//)
    cols_on_ticket = str[7..str.size].split(//)

    while plane_rows.size > 1
      row = rows_on_ticket.shift
      plane_rows = seat_splitter(row, plane_rows)
    end

    while plane_columns.size > 1
      col = cols_on_ticket.shift
      plane_columns = seat_splitter(col, plane_columns)
    end

    return plane_rows.first * SEAT_ID_MODIFIER + plane_columns.first
  end

  def seat_splitter(char, arr)
    return arr if arr.size == 1
    pivot = arr.size / 2
    return arr[0...pivot] if char == 'F' || char == 'L'
    return arr[pivot..arr.size] if char == 'B' || char == 'R'
  end
end

