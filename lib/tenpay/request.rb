require 'digest/md5'
require 'cgi'
require 'iconv'

module Tenpay
  class Request
    GATEWAY_URL = "https://www.tenpay.com/cgi-bin/v1.0/pay_gate.cgi"

    def initialize(description, order_id, total_fee, 
                    return_url, purchaser_ip='', attach=nil)
      @cmdno = 1
      @date  = Date.today.strftime("%Y%m%d")
      @bank_type = 0
      @fee_type = 1
      
      @desc = Iconv.iconv('gbk', 'utf-8', description).join
      @spid = Tenpay::Config.spid
      @key = Tenpay::Config.key
      
      @order_id = order_id.to_i
      @total_fee = total_fee.to_i
      @return_url = return_url
      @attach = attach || 'nil'
      
      @purchaser_ip = (RAILS_ENV == 'production' ? purchaser_ip : '')
    end
    
    def transaction_id
      @transaction_id ||= "%s%s%010d" % [@spid, @date, @order_id]
    end
    
    def sign
      @sign ||= Digest::MD5.hexdigest(sign_params).upcase
    end
    
    def sign_params
      @sign_params ||= generate_sign_params
    end
    
    def params
      @params ||= generate_params
    end
    
    def url
      "#{GATEWAY_URL}?#{params}&sign=#{sign}"
    end
    
    private
    def generate_params
      params = "cmdno=#{@cmdno}&date=#{@date}&bargainor_id=#{@spid}&transaction_id=#{transaction_id}" +
                "&sp_billno=#{@order_id}&total_fee=#{@total_fee}&fee_type=#{@fee_type}" +
          "&return_url=#{@return_url}&attach=#{CGI.escape(@attach)}&desc=#{CGI.escape(@desc)}"
      params << "&spbill_create_ip=#{@purchaser_ip}" unless @purchaser_ip.nil? || @purchaser_ip == ''
      params
    end
    def generate_sign_params
      sign_params = "cmdno=#{@cmdno}&date=#{@date}&bargainor_id=#{@spid}&transaction_id=#{transaction_id}" +
                "&sp_billno=#{@order_id}&total_fee=#{@total_fee}&fee_type=#{@fee_type}" +
                "&return_url=#{@return_url}&attach=#{CGI.escape(@attach)}"
      sign_params << "&spbill_create_ip=#{@purchaser_ip}" unless @purchaser_ip.nil? || @purchaser_ip == ''
      sign_params << "&key=#{@key}"
    end
  end
end