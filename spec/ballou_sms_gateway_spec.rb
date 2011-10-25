describe BallouSmsGateway do
  let(:long_message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a" }
  let(:message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostr" }
  
  it "should raise an error if message is to long" do
    lambda {
      BallouSmsGateway.new.message(long_message).send!
    }.should raise_error("Message is to long, 201 characters.")
  end
end