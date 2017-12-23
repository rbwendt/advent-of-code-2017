class Sounder
    attr_reader :dpnt, :ptr, :instructions

    def initialize(instructions, rq = nil, wq = [], id = 0)
        
        @instructions = instructions
        @rq = rq || wq
        @wq = wq
        @h=Hash.new{ |h,k| h[k]=0 }
        @h['p'] = id
        @ptr = 0

        @id = id
    end
    
    def registers
        @h
    end

    def s_to_i(inp)
        Integer(inp)
    rescue ArgumentError
        return @h[inp]
    end

    def set x, v
        @h[x] = (s_to_i v)
    end

    def add x, v        
        @h[x] += (s_to_i v)
    end

    def mul x, v
        @h[x] *= (s_to_i v)
    end

    def mod x, v
        @h[x] %= (s_to_i v)
    end

    def snd v
        @wq << (s_to_i v)
    end

    def rcv l
        if @rq.empty?
            @dpnt = 0
        else
            @dpnt = 1
            v = @rq.shift

            @h[l] = v
        end        
    end

    def jgz x, v
        @dpnt = if @h[x] > 0
            s_to_i v
        else
            1
        end
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
            @ptr += @dpnt
        end
    end

    def step
        parts = @instructions[@ptr].split(' ')
        instruction = parts.shift
        rest = parts
        
        send instruction, *rest
        unless ['jgz', 'rcv'].include? instruction
            @dpnt = 1
        end
    end
end

class SounderA < Sounder

    def rcv l
        if @h[l] > 0
            v = @rq.pop
            
            puts "answer A is #{v}"
            
            @ptr = @instructions.length
        end
    end
end

class SounderB < Sounder
    attr_reader :sends
    def snd v
        @sends ||= 0
        @sends += 1
        super v
    end
end

def part_a
    instructions = (File.read 'data/day18.txt').split("\n")

    sounder = SounderA.new(instructions)
    sounder.run    
end

def part_b
    
    instructions = (File.read 'data/day18.txt').split("\n")

    q1 = []
    q2 = []

    sounder1 = SounderB.new(instructions, q1, q2, 0)
    sounder2 = SounderB.new(instructions, q2, q1, 1)

    while sounder1.ptr < sounder1.instructions.size && sounder1.ptr > -1 && sounder2.ptr < sounder2.instructions.size && sounder2.ptr > -1

        sounder1.step
        sounder2.step
        if sounder1.dpnt == 0 
            if sounder2.dpnt == 0
                if q1.empty? && q2.empty?
                    break
                end
            end
        end
    end
    puts "1: #{(sounder1.registers).inspect}"
    puts "2: #{(sounder2.registers).inspect}"

    puts "answer B: #{sounder1.sends}"
end

part_a # 7071
part_b # 8001
