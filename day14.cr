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
        s += d.to_s(2).split("")
    end

    s
end

def concat_lengths(a)
    a + [17_u8, 31_u8, 73_u8, 47_u8, 23_u8]
end

def knot_hash(s : String)
    dense_hash(sparse_hash(concat_lengths(convert_to_ascii(s))))
end

def rpad(str, len, char)
    while str.size < len
        str = "#{str}#{char}"
    end
    str
end

def contains(cont, thing)
    cont.reduce(false){|a,r| a || r.includes?(thing)}
end

def count_regions(cont)
    regions = 0
    
    while (contains(cont, "1"))
        regions += 1
        to_check = [] of Int32
        to_check << idx

        while (idx2 = to_check.shift)
            puts to_check.size
            if str[idx] == '1'
                str = set_at(cont, idx, "0")
                
                to_check << idx2 + 1 if idx2 + 1 < str.size
                to_check << idx2 + 128 if idx2 + 128 < str.size
            end
        end
    end

    regions
end

input_prefix = "flqrgnkx"
# input_prefix = "stpzcrnm"

def part_a(input_prefix)
    inputs = 0.upto(127).to_a.map {|i| "#{input_prefix}-#{i}"}
    binaries = inputs.map{|i| knot_hash(i)}.join("")
    ones = binaries.gsub(/0/, "")
    ones.size
end

def set_at(str, idx, char)
    "#{str[0..idx-1]}#{char}#{str[idx+1..str.size]}"
end

def part_b(input_prefix)
    inputs = 0.upto(127).to_a.map {|i| "#{input_prefix}-#{i}"}
    binaries = inputs.map{|i| knot_hash(i)}
    padded = binaries.map{|str| rpad(str, 127, "0")}
    joined = padded.join("")
    regions = count_regions(joined)
end

puts part_a(input_prefix)
puts part_b(input_prefix)

str = "abc123"
idx = str.index('1')
unless idx.nil?
    puts set_at(str, idx, "0")
end