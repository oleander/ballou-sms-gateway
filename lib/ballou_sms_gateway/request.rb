module BallouSmsGatewayModule
  class Request < Struct.new(:id, :to, :status, :error)
    
    #
    # @return Boolean Did everything went okay?
    #
    def send?
      error == 0
    end    
  end
end