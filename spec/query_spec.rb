ENV["RAILS_ENV"] = "test"
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require "tenpay"
require 'net/http'

describe Tenpay::Request do
  before do
    @query = Tenpay::Query.new(1, Date.new(2009, 9, 12))
    @sign_params = "attach=nil&bargainor_id=1900000109&charset=UTF-8&cmdno=2&date=20090912&output_xml=1&" +
              "sp_billno=1&transaction_id=1900000109200909120000000001&key=8934e7d15453e97507ef794cf7b0519d"
    @sign = Digest::MD5.hexdigest(@sign_params).upcase
    @params = "cmdno=2&date=20090912&bargainor_id=1900000109&transaction_id=1900000109200909120000000001" +
              "&sp_billno=1&attach=nil&output_xml=1&charset=UTF-8&sign=#{@sign}"
  end
  
  it "should return a Query Response object." do
    @uri = mock('uri')
    URI.should_receive(:parse).with("#{Tenpay::Query::GATEWAY_URL}?#{@params}").and_return(@uri)
    Net::HTTP.should_receive(:get).with(@uri)
    Tenpay::QueryResponse.stub!(:new).and_return(mock('response'))
    @query.response
  end
  
  it "should construct sign params properly." do
    @query.sign_params.should == @sign_params
  end
end

describe Tenpay::QueryResponse do
  before do
    @valid_response   = VALID_XML
    @invalid_response = ''
  end
  
  it "should be invalid with invalid response" do
    @response = Tenpay::QueryResponse.new(@invalid_response)
    @response.should_not be_valid
  end
  
  it "should be valid with valid response" do
    @response = Tenpay::QueryResponse.new(@valid_response)
    @response.attach.should == 'a'
    @response.cmdno.should == '2'
    @response.date.should == '20090315'
    @response.fee_type.should == '1'
    @response.pay_info.should == 'test'
    @response.pay_result.should == '2006'
    @response.order_id.should == '56212087'
    @response.total_fee.should == '3000'
    @response.transaction_id.should == '1900000108200903150056212087'
    @response.sign.should == 'A8D50F1DC2E2E4CC83191AE39C702C27'
    
    @response.should be_valid
  end
  
  VALID_XML = %(<?xml version="1.0" encoding="GB2312" ?>
  <root> 
    <attach>a</attach>  
    <bank_type />  
    <bargainor_id>1900000108</bargainor_id>  
    <bill_no />  
    <charset>GB2312</charset>  
    <cmdno>2</cmdno>  
    <date>20090315</date>  
    <dump_html_file />  
    <fee_type>1</fee_type>  
    <output_xml>1</output_xml>  
    <pay_info>test</pay_info>
    <pay_result>2006</pay_result>  
    <retcode>00</retcode>  
    <retmsg>交易成功</retmsg>  
    <return_url>http://192.168.1.129/bank/cft_return.aspx</return_url>  
    <sign>A8D50F1DC2E2E4CC83191AE39C702C27</sign>  
    <sp_billno>56212087</sp_billno>  
    <total_fee>3000</total_fee>  
    <transaction_id>1900000108200903150056212087</transaction_id>  
  </root>
  )
end