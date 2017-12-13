struct ParseResult
  property name, weight, child_names
  
  def initialize(@name : String, @weight : Int32, @child_names : Array(String))
    end
end
  
class TreeNode
  property name, weight, children, parent : TreeNode | Nil
  
  def initialize(@name : String, @weight : Int32)
    @children = [] of TreeNode
    @parent = nil
  end

  def get_weight() : Int32
    weight + if children.size > 0
      weights = children.map do |child|
        (child.get_weight()).as(Int32)
      end
      weights.reduce(0) {|a, r| a + r}
    else
      0
    end
  end

  def get_child_names(): Array(String)
    children.map {|c| c.name}
  end

  def get_child_weights() : Array(Int32)
    children.map {|c| c.get_weight() }
  end

  def get_unbalanced_child(): TreeNode | Nil
    weights = get_child_weights()

    if weights == weights.uniq
      return nil
    end

    i = 0
    unbalanced_index = 0
    loop do
      if weights[i] != weights[(i + 1) % weights.size]
        if weights[i] == weights[(i + 2) % weights.size]
          unbalanced_index = (i + 1) % weights.size
        else
          unbalanced_index = i
        end
        break
      end
      i += 1
    end
    children[unbalanced_index]
  end
end

inputs = File.read("data/day7.txt").split("\n")
map = {} of String => TreeNode

parsed = inputs.map do |line|
  matches = /([a-z]+) \((\d+)\)( -> )?(.+)?/.match(line)
  name = ""
  unless matches.try &.[1].nil?
    name = matches.try &.[1]
  end
  weight = 0
  weight_str = (matches.try &.[2])
  unless weight_str.nil?
  	weight = weight_str.to_i(10)
  end
  children_str = ""
  begin
    if matches.try &.[4]
  		children_str = (matches.try &.[4])
    end
  rescue e
  end
  if children_str.nil?
	children_str = ""
  end
  children_strs = children_str.split(", ")

  keyname = ""
  unless name.nil?
	keyname = name
  end
    map[keyname] = TreeNode.new(keyname, weight)
	ParseResult.new(keyname, weight, children_strs)
end

parsed.each do |parse_result|
	if parse_result.child_names.size > 0 && parse_result.child_names[0] != ""
		map[parse_result.name].children =
		parse_result.child_names.map do |child_name|
			map[child_name].parent = map[parse_result.name]
			map[child_name]
        end
	end
end

name = parsed[0].name
node = map[name]
loop do
	parent = node.parent
	if parent.nil?
		break
	else
		name = parent.name
		node = parent
	end
end

puts "the final name is #{name}"
node = map[name]
puts "children: #{node.get_child_names()}"
puts "weights: #{node.get_child_weights()}"

def drill_down(input_node, correction = 0) : Nil
  unbalanced = input_node.get_unbalanced_child()

  if unbalanced.nil?
    puts "could not find unbalanced node"
  else
    childs = unbalanced.get_child_weights()
    puts "name of unbalanced = #{unbalanced.name} weight: #{unbalanced.weight} weights: #{childs}"
    if childs.uniq.size > 1
      drill_down(unbalanced, childs.max - childs.min)
    else
      puts "correction was #{correction}, so value is #{unbalanced.weight - correction}"
    end
  end
end

drill_down(node)

#the output 646.
