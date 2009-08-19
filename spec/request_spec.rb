ENV["RAILS_ENV"] = "test"
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require "tenpay"

describe Tenpay::Request do
  before do
    @request = Tenpay::Request.new('test product', 1, 
	                 4500, 'http://return', 'order_id=1')
    today = Date.today
    @date = "%d%02d%02d" % [today.year, today.month, today.day]
    @params = "cmdno=1&date=#{@date}&bargainor_id=1900000109&" +
        "transaction_id=1900000109#{@date}0000000001&sp_billno=1&total_fee=4500&fee_type=1" +
        "&return_url=#{'http://return'}&attach=#{CGI.escape('order_id=1')}"
    @sign = Digest::MD5.hexdigest("#{@params}&key=8934e7d15453e97507ef794cf7b0519d").upcase
  end
  
  it "should construct transaction correctly." do
    @request.transaction_id.should == "1900000109#{@date}0000000001"
  end
  
  it "should construct params correctly." do
    @request.params.should == "#{@params}&desc=test product"
  end
  
  it "should sign the params" do
    @request.sign.should == @sign
  end
  
  it "should generate url for user paying" do
    @request.url.should == "https://www.tenpay.com/cgi-bin/v1.0/pay_gate.cgi?#{@params}&desc=test product&sign=#{@sign}"
  end
end