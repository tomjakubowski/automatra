require './lib/automaton'

describe Automaton do
  describe "rule sanity checks" do
    it "should disallow a rule which is not an Integer" do
      lambda do
        pie = Automaton.new(3.14159, 0xdeadbeef)
      end.should raise_error
    end

    it "should disallow a negative value rule" do
      lambda do
        nancy = Automaton.new(-1, 0xdeadbeef)
      end.should raise_error
    end

    it "should disallow a rule over 255" do
      lambda do
        toohigh = Automaton.new(256, 0xdeadbeef)
      end.should raise_error
    end
  end
  
  describe "initial state" do
    it "should reject an initial state which is neither an Integer nor an Array" do
      lambda do
        pie = Automaton.new(110, 3.14159)
      end.should raise_error
    end
    
    it "should disallow a negative Integer initial state" do
      lambda do
        nancy = Automaton.new(110, -255)
      end.should raise_error
    end
    
    it "should convert an Integer state to the equivalent bit array" do
      steak = Automaton.new(110, 0xdeadbeef, 32)
      steak.state.join('').should == 0xdeadbeef.to_s(2)
    end
    
    it "should pad the bit array to match the specified width" do
      padded = Automaton.new(110, 1, 8)
      padded.state.should == [0, 0, 0, 0, 0, 0, 0, 1]
    end
  end
  
  describe "state changes" do
    before(:each) do
      @shorty = Automaton.new(110, 1, 8)
    end
    
    it "should not be mutated when next_state is called" do
      original_state = @shorty.state
      @shorty.next_state
      @shorty.state.should == original_state
    end
    
    it "should be mutated when next_state! is called" do
      original_state = @shorty.state
      @shorty.next_state!
      @shorty.state.should_not == original_state
    end
    
    it "should generate the next state according to its rule" do
      @shorty.next_state.should == [0,0,0,0,0,0,1,1]
    end
    
    it "should generate the correct state after several steps" do
      7.times { @shorty.next_state! }
      @shorty.state.should == [1,1,0,1,0,1,1,1]
    end
  end
end