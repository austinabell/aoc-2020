def count_seats(s)
    count = 0
    s.each_with_index do |row, i|
        row.each_with_index do |seat, j|
            if seat == "#"
                count += 1
            end
        end
    end
    count
end

def part1(seats)
    rows = seats.length
    cols = seats[0].length
    while true
        n = seats.clone.map(&:clone)
        n.each_with_index do |row, i|
            row.each_with_index do |seat, j|
                if seat == "."
                    next
                end
                adj = 0
                for l in i-1..i+1
                    if l < 0 || l >= rows
                        next
                    end
    
                    for k in j-1..j+1
                        if k < 0 || k >= cols || (l == i && j == k)
                            next
                        end
                        if seats[l][k] == "#"
                            adj += 1
                        end
                    end
                end
                if seat == "#" && adj >= 4
                    n[i][j] = "L"
                elsif seat == "L" && adj == 0
                    n[i][j] = "#"
                end
            end
        end
        if n == seats
            break
        end
        seats = n.clone.map(&:clone)
    end
    seats
end

def part2(seats)
    rows = seats.length
    cols = seats[0].length

    vectors = [[-1, -1],[-1, 0],[-1, 1],[0, -1],[0, 1],[1, -1],[1, 0],[1, 1]]

    while true
        n = seats.clone.map(&:clone)
        n.each_with_index do |row, i|
            row.each_with_index do |seat, j|
                if seat == "."
                    next
                end

                adj = 0

                vectors.each do |v|
                    l, k = i, j
                    loop do
                        l += v[0]
                        k += v[1]
                        if l < 0 || l >= rows || k < 0 || k >= cols || seats[l][k] == "L"
                            break
                        elsif seats[l][k] == "#"
                            adj +=1
                            break
                        end
                    end
                end

                if seat == "#" && adj >= 5
                    n[i][j] = "L"
                elsif seat == "L" && adj == 0
                    n[i][j] = "#"
                end
            end
        end
        if n == seats
            break
        end
        seats = n.clone.map(&:clone)
    end
    seats
end

file_path = File.expand_path('input.txt', __dir__)
input     = File.read(file_path)

rows = input.split("\n")

input = []

rows.each do |r|
    input.push(r.split(""))
end

p count_seats(part1(input.clone.map(&:clone)))
p count_seats(part2(input))
