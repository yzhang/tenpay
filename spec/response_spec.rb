ENV["RAILS_ENV"] = "test"
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require "tenpay"

describe Tenpay::Response do
  before do
    @valid_params = {:cmdno => '1', :date => '20090818',
                          :fee_type => '1', :pay_info => 'OK', :pay_result => '0',
                          :pay_time => '1250554120',
                          :sign => 'D2171C4319EE7A7A8008F1A4479C8C93',
                          :sp_billno => '2',
                          :transaction_id => '1900000109200908180000000002',
                          :total_fee => '1',
                          :attach => 'nil'}
  end
  
  it "should be successful with valid params and key" do
    Tenpay::Response.new(@valid_params).should be_successful
  end
  
  it "should not be successful with invalid params and key" do
    @valid_params[:date] = '20100912'
    Tenpay::Response.new(@valid_params).should_not be_successful
  end
end