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
    s = ""
    sparse.each_slice(16) do |slice|
        d = slice.reduce(slice.shift) { |a, r| a ^ r }
        s += d.to_s(16)
    end

    s
end

def concat_lengths(a)
    a + [17_u8, 31_u8, 73_u8, 47_u8, 23_u8]
end

def full_hash(s : String)
    dense_hash(sparse_hash(concat_lengths(convert_to_ascii(s))))
end

input1 = [206_u8,63_u8,255_u8,131_u8,65_u8,80_u8,238_u8,157_u8,254_u8,24_u8,133_u8,2_u8,16_u8,0_u8,1_u8,3_u8]
input2 = "206,63,255,131,65,80,238,157,254,24,133,2,16,0,1,3"

list = weird_hash(input1)

puts "Part A: output: #{list[0]} * #{list[1]} = #{list[0] * list[1]}"
puts "Part B: #{full_hash(input2)}"