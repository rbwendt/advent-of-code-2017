def reverse_between(list : Array(Int32), from : UInt8, count : UInt8)
    new_list = [] of Int32

    i = 0
    while i < list.size
        new_list << list[i]
        i += 1
    end

    i = 0
    while i < count
        pos = (from + i) % list.size
        switch_pos = (from + count - i - 1) % list.size
        
        new_list[pos] = list[switch_pos]
        i += 1
    end

    new_list
end

def weird_hash(inputs : Array(UInt8), rounds = 1)
    list = (0..255).to_a

    position = 0_u8
    skip_size = 0_u8
    
    i = 0_u8
    while i < rounds
        inputs.each do |input|
            list = reverse_between(list, position, input)
            position += input + skip_size
            position %= list.size
            skip_size += 1
        end
        i += 1
    end

    list
end

def convert_to_ascii(str : String)
    str.bytes()
end

def sparse_hash(inputs)
    weird_hash(inputs, 64)
end

def dense_hash(sparse)
    s = [] of String
    sparse.each_slice(16) do |slice|
        d = slice.reduce(slice.shift) { |a, r| a ^ r }
        s += lpad(d.to_s(2), 8, '0').split("")
    end

    s
end

def concat_lengths(a)
    a + [17_u8, 31_u8, 73_u8, 47_u8, 23_u8]
end

def knot_hash(s : String)
    dense_hash(sparse_hash(concat_lengths(convert_to_ascii(s))))
end

def lpad(str, len, char)
    while str.size < len
        str = "#{char}#{str}"
    end
    str
end

def contains(cont, thing)
    cont.each_with_index do |yeah, i|
        yeah.each_with_index do |yeah_yeah, j|
            if yeah_yeah == thing
                return [i, j]
            end
        end
    end
    [-1, -1]
end

def zero_out_region(array, coords)
    array[coords[0]][coords[1]] = 0
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |diff|
        if array[coords[0] + diff[0]][coords[1] + diff[1]] == 1
            array = zero_out_region(array, [coords[0] + diff[0], coords[1] + diff[1]])
        end
    end
    array
end

def count_regions(cont)
    regions = 0
    
    while ((coords = contains(cont, 1)) != [-1, -1])
        regions += 1
        # puts "region ++: #{regions}"
        cont = zero_out_region(cont, coords)
    end

    regions
end

def set_at(arr, idx1, idx2, ner)
    arr[idx1][idx2] = ner
    arr
end

def zero_pad(arr)
    ([[0] * (arr.size + 2)]) + arr.map {|a| [0] + a + [0]} + ([[0] * (arr.size + 2)])
end

def part_a(input_prefix)
    inputs = 0.upto(127).to_a.map {|i| "#{input_prefix}-#{i}"}
    binaries = inputs.map{|i| knot_hash(i)}.join("")
    ones = binaries.gsub(/0/, "")
    ones.size
end

def part_b(input_prefix)
    inputs = 0.upto(127).to_a.map {|i| "#{input_prefix}-#{i}"}
    binaries = inputs.map{|i| knot_hash(i)}
    padded = zero_pad(binaries.map{|arr| lpad(arr.join(""), 127, "0")}.map{|x| x.split("").map{|y| y.to_i}})
    puts count_regions(padded)
end

input_prefix = "flqrgnkx"
input_prefix = "stpzcrnm"

puts part_a(input_prefix)
puts part_b(input_prefix)
