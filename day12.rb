z = IO.read('data/day12.txt').split("\n").map{|s| v=s.gsub(/ <->/, ',').split(', ').map(&:to_i)}.each_with_object({}){|x, h| h[x.shift] = x}

class AllConnections
  def initialize(h)
    @h = h
    @connected_to = []
  end

  def find_all_connections(idx = 0)
    @h[idx].each do |idx2|
      next if @connected_to.include? idx2

      @connected_to << idx2
      find_all_connections(idx2)
    end
    @connected_to
  end

  def get_groups_count
    conns = find_all_connections
    ct = 1

    while idx = (@h.keys - conns).first
      conns += find_all_connections(idx)
      ct += 1
    end

    ct
  end
end

ac = AllConnections.new(z)
conns = ac.find_all_connections
puts "part 1: #{conns.size}"
puts "part 2: #{ac.get_groups_count}"
