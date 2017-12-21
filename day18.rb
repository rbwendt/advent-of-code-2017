class Sounder
    def initialize(instructions, q = Queue.new, rcv_callback = nil)
        @instructions = instructions
        @q=q
        @h=Hash.new{|h,k| h[k]=0 }
        @pnt = 0
        @rcv_callback = rcv_callback
    end

    def s_to_i(inp)
        Integer(inp)
    rescue ArgumentError
        return @h[inp]
    end

    def set x, v
        v = s_to_i v 
        
        @h[x] = v
        # puts "set #{x} to #{v}, (#{$h[x]})"
    end

    def add x, v
        v = s_to_i v
        
        @h[x] = @h[x] + v
    end

    def mul x, v
        v = s_to_i v
        
        @h[x] *= v
    end

    def snd v
        v = s_to_i v
        
        @q.push v
    end

    def rcv l
        if @h[l] > 0
            v = @q.shift
        
            @h[l] = v
        end
    end

    def mod x, v
        v = s_to_i v
        
        if @h[x] != 0
            @h[x] = @h[x] % v
        end
    end

    def jgz x, v
        v = s_to_i v
        
        if @h[x] == 0
            return
        end
        
        v
    end

    'a'.upto('z').each do |letter|
        define_method letter do |value|
            [letter, value]
        end
    end

    def run
        @ptr = 0
        while @ptr < @instructions.size && @ptr > -1
            step
        end
    end

    def step
        parts = @instructions[@ptr].split(' ')
        instruction = parts.shift
        rest = parts
        if instruction == 'jgz'
            diff = send instruction, *rest
            if diff.nil?
                @ptr += 1
            else
                @ptr += diff
            end
        else
            send instruction, *rest
            @ptr += 1
        end
    end
end

class SounderA < Sounder
    def snd v
        v = s_to_i v
        
        @q = Queue.new
        @q.push v
    end

    def rcv l
        if @h[l] > 0
            v = @q.shift
            
            puts "answer A is #{v}"
            @ptr = @instructions.length
            @h[l] = v
        end
    end
end

def part_a
    instructions = (File.read 'data/day18.txt').split("\n")

    sounder = SounderA.new(instructions)
    sounder.run    
end

def part_b
    
    instructions = (File.read 'data/day18.txt').split("\n")

    sounder1 = Sounder.new(instructions)
    sounder2 = Sounder.new(instructions)
    
end

part_a
part_b
