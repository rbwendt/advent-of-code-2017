$snd=0
$h=Hash.new{|h,k| h[k]=0 }
$pnt = 0

def s_to_i(inp)
    Integer(inp)
rescue ArgumentError
    return inp
end

def set x, v
    v = s_to_i v 
    if v.is_a? String
        v = $h[v]
    end
    $h[x] = v
    puts "set #{x} to #{v}, (#{$h[x]})"
end

def add x, v
    v = s_to_i v
    if v.is_a? String
        v = $h[v]
    end
    $h[x] = $h[x] + v
    puts "add #{x} to #{v}, (#{$h[x]})"
end

def mul x, v
    v = s_to_i v
    if v.is_a? String
        v = $h[v]
    end
    $h[x] *= v
end

def snd v
    v = s_to_i v
    if v.is_a? String
        v = $h[v]
    end
    
    $snd = v
end

def rcv l
    puts "receive #{$h.inspect} #{$snd}"
    if $h[l] > 0
        puts "answer is #{$snd}"
        abort
        $h[l] = $snd
    end
    puts "receive #{$h.inspect} #{$snd}"
end

def mod x, v
    v = s_to_i v
    if v.is_a? String
        v = $h[v]
    end
    if $h[x] != 0
        $h[x] = $h[x] % v
    end
end

def jgz x, v
    v = s_to_i v
    if v.is_a? String
        v = $h[v]
    end
    if $h[x] == 0
        return
    end
    puts "jump by #{v} (#{$h[x]})"
    v
end

'a'.upto('z').each do |letter|
    define_method letter do |value|
        [letter, value]
    end
end

def part_a
    instructions = (File.read 'data/day18.txt').split("\n")

    puts instructions.inspect
    $ptr = 0
    while $ptr < instructions.size && $ptr > -1
        puts instructions[$ptr].split(' ').inspect
        parts = instructions[$ptr].split(' ')
        instruction = parts.shift
        rest = parts
        puts "instruction: #{instruction}, rest: #{rest.inspect}"
        if instruction == 'jgz'
            puts 'it is a jpg sorry'
            puts $h.inspect
            diff = send instruction, *rest
            # return
            puts "diff #{diff.inspect}"
            if diff.nil?
                $ptr += 1
            else
                $ptr += diff
            end
            puts "#{$h.inspect} #{$ptr}"
            # abort
        else
            send instruction, *rest
            $ptr += 1
        end
    end
    puts $h.inspect
end

part_a