describe BallouSmsGateway do
  let(:long_message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a" }
  let(:message) { "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostr" }
  let(:gateway) { BallouSmsGateway.new }
  let(:from) { "Person A" }
  let(:to) { "0702211444" }
  let(:id) { "858426d0-e17c-012e-9cc9-58b035fcfcff" }
  let(:request_id) { "345b9360-e17c-012e-9c99-58b035fcfcff" }
  
  describe "#message" do
    before(:each) do
      RestClient.should_receive(:get).any_number_of_times
    end
    
    it "should raise an error if message is to long" do
      lambda {
        gateway.message(long_message).send!
      }.should raise_error("Message is to long, 201 characters.")
    end
    
    it "should not raise error if message is to long, if #long is used" do
      lambda {
        gateway.long.message(long_message).send!
      }.should_not raise_error("Message is to long, 201 characters.")
    end
  end
  
  describe "#send!" do
    before(:each) do
      RestClient.should_receive(:get).any_number_of_times
    end
    
    it "should raise error if we're trying to send a non valid message" do
      lambda {
        gateway.message(message).send!
      }.should raise_error("You need to specify from, using the #from method.")
      
      lambda {
        gateway.from(from).message(message).send!
      }.should raise_error("You need to specify to, using the #to method.")
      
      lambda {
        gateway.from(from).to(to).message(message).send!
      }.should raise_error("You need to specify password, using the #password method.")
      
      lambda {
        gateway.from(from).to(to).message(message).send!
      }.should raise_error("You need to specify password, using the #password method.")
      
      lambda {
        gateway.from(from).to(to).password("password").message(message).send!
      }.should raise_error("You need to specify username, using the #username method.")
    end
  end
  
  describe "#to" do
    before(:each) do
      RestClient.should_receive(:get).any_number_of_times
    end
    
    it "should fail duo to invalid phonenumber" do
      ["invalid", "070-123-123", "070invalid", ["invalid"], "070+220022"].each do |number|
        lambda {
          gateway.to(number)
        }.should raise_error("Invalid receiver.")
      end
    end
    
    it "should not fail" do
      ["070123123", ["070229393", "+070203993"], "8372928384"].each do |number|
        lambda {
          gateway.to(*number)
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
  
  describe "#request_id and #id" do
    it "should be possible to pass id" do
      stub_request(:get, /.*/).to_return(status: 200)
      request = gateway.
        password(USER["password"]).
        username(USER["username"]).
        from("BallouSms").
        to(USER["phone"]).
        id("my_custom_id").
        request_id(request_id).
        message("This is an example").
        send!
      a_request(:get, /CR=my_custom_id/).should have_been_made.once
    end
    
    it "should be possible to pass request_id" do
      stub_request(:get, /.*/).to_return(status: 200)
      request = gateway.
        password(USER["password"]).
        username(USER["username"]).
        from("BallouSms").
        to(USER["phone"]).
        id(id).
        request_id("my_custom_request_id").
        message("This is an example").
        send!
      a_request(:get, /RI=my_custom_request_id/).should have_been_made.once
    end
  end
  
  describe "request" do
    use_vcr_cassette "valid-request"
        
    it "should be possible to send a message" do
      request = gateway.
        password(USER["password"]).
        username(USER["username"]).
        from("BallouSms").
        to(USER["phone"]).
        id(id).
        request_id(request_id).
        message("This is an example").
        send!
      
      request.id.should eq("219578214912")
      request.sms_id.should eq(id)
      request.request_id.should eq(request_id)
      request.to.should eq(USER["phone"])
      request.status.should eq(-1)
      request.error.should eq(0)
      request.message.should be_empty
      request.should be_sent
    end
    
    it "should send message to invalid receiver" do
      request = gateway.
        password(USER["password"]).
        username(USER["username"]).
        from("BallouSms").
        to("07011").
        id(id).
        request_id(request_id).
        message("This is an example").
        send!
      
      request.to.should eq("07011")
      request.status.should eq(-2)
      request.sms_id.should eq(id)
      request.request_id.should eq(request_id)
      request.error.should eq(3)
      request.should_not be_sent
    end
    
    it "should be able to handle request errors" do
      stub_request(:get, /.*/).to_return(status: 404)
      request = gateway.
        password(USER["password"]).
        username(USER["username"]).
        from("BallouSms").
        to(USER["phone"]).
        id(id).
        request_id(request_id).
        message("This is an example").
        send!
      
      request.to.should eq(USER["phone"])
      request.status.should eq(-2)
      request.sms_id.should eq(id)
      request.request_id.should eq(request_id)
      request.error.should eq(7)
      request.should_not be_sent
      request.message.should eq("404 Resource Not Found")
    end
  end
  
  describe "invalid request" do
    use_vcr_cassette "invalid-request"
    
    it "should be able to handle error messages" do
      request = gateway.
        password("invalid").
        username("invalid").
        from("BallouSms").
        to(USER["phone"]).
        id(id).
        request_id(request_id).
        message("This is an example").
        send!
        
      request.should_not be_valid
      request.should_not be_sent
      request.error.should eq(2)
      request.status.should eq(-2)
      request.message.should eq("Authentication failed or IP rejected")
    end
  end
end