class Automaton 
  attr_accessor :rule, :state
  
  def initialize(rule, initial_state=1, width=512)
    raise "rule must be an Integer" unless rule.is_a? Integer
    raise "rule must not be less than 0 or exceed 255" if (rule < 0 || rule > 255)
    @rule = Array.new(8) { |n| rule[n] }.reverse!
    configure_rule_hash(@rule)
    if initial_state.is_a? Integer
      raise "Integer initial_state must be non-negative" unless initial_state >= 0
      @state = Array.new(width) { |n| initial_state[n] }.reverse!
    elsif initial_state.is_a? Array 
      @state = initial_state
    else
      raise "initial_state must be a positive Integer or an Array"
    end
  end
  
  def next_state
    # find and return the next state using the automaton's rule
    new_state = []
    @state.each_with_index { |b, i| new_state.push new_cell_state(neighbors(i)) }
    new_state
  end
  
  def next_state!
    @state = next_state
  end

  protected

  def configure_rule_hash(rule)
    # 8-member array of bit fields representing each integer in [7,0]
    neighborhoods = Array.new(8) do |n|
      Array.new(3) { |bit| n[bit] }.reverse!
    end.reverse!
    @rule_hash = Hash[neighborhoods.zip(rule)]
  end
  
  def neighbors(position)
    if (position + 1 == @state.length)
      [@state[position - 1], @state[position], @state[0]]
    else
      [@state[position - 1], @state[position], @state[position + 1]]
    end
  end
  
  def new_cell_state(neighborhood)
    @rule_hash[neighborhood]
  end
end