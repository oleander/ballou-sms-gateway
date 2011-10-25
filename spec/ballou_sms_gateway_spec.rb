describe BallouSmsGateway do
  let(:long_message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a" }
  let(:message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostr" }
  
  it "should raise an error if message is to long" do
    lambda {
      BallouSmsGateway.new.message(long_message).send!
    }.should raise_error("Message is to long, 201 characters.")
  end
  
  describe "#to" do
    before(:each) do
      RestClient.should_receive(:get).any_number_of_times
    end
    
    it "should fail duo to invalid phonenumber" do
      ["invalid", "070-123-123", "070invalid", ["invalid"]].each do |number|
        lambda {
          BallouSmsGateway.new.message(message).to(number).send!
        }.should raise_error("Invalid receiver.")
      end
    end
    
    it "should not fail" do
      ["070123123", ["070229393", "+070203993"], "8372928384"].each do |number|
        #lambda {
          BallouSmsGateway.new.message(message).to(number).send!
        #}.should_not raise_error
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