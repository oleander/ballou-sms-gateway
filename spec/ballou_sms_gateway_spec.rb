describe BallouSmsGateway do
  let(:long_message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a" }
  let(:message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostr" }
  let(:gateway) { BallouSmsGateway.new }
  
  it "should raise an error if message is to long" do
    lambda {
      gateway.message(long_message).send!
    }.should raise_error("Message is to long, 201 characters.")
  end
  
  describe "#to" do
    before(:each) do
      RestClient.should_receive(:get).any_number_of_times
    end
    
    it "should fail duo to invalid phonenumber" do
      ["invalid", "070-123-123", "070invalid", ["invalid"]].each do |number|
        lambda {
          gateway.to(number)
        }.should raise_error("Invalid receiver.")
      end
    end
    
    it "should not fail" do
      ["070123123", ["070229393", "+070203993"], "8372928384"].each do |number|
        lambda {
          gateway.to(number)
        }.should_not raise_error
      end
    end
  end
  
  describe "#from" do
    it "should fail, it's to long - or short" do
      ["aaaaaaaaaaaa", "12345678910111213141516", ""].each do |number|
        lambda {
          gateway.from(number)
        }.should raise_error(RuntimeError)
      end
    end
    
    it "should not fail" do
      ["aaaaaaaaaa", "123456789123456", "a", "1"].each do |number|
        lambda {
          gateway.from(number)
        }.should_not raise_error
      end
    end
    
  end
    
  context "fake request" do
    before(:each) do
      # RestClient.should_receive(:get).once
    end
    
    it "should validate sender" do
      # lambda {
      #   BallouSmsGateway.new.message(long_message).send!
      # }.should raise_error("Message is to long, 201 characters.")
    end
  end  
end