require 'digest/md5'
require 'cgi'
require 'iconv'
require 'net/http'
require 'uri'
require 'hpricot'

module Tenpay
  class Query
    GATEWAY_URL = "http://mch.tenpay.com/cgi-bin/cfbi_query_order_v3.cgi"

    def initialize(order_id, date, attach=nil, charset='UTF-8')
      @cmdno = 1
      @date  = date.strftime("%Y%m%d")
      @spid = Tenpay::Config.spid
      @key = Tenpay::Config.key
      
      @order_id = order_id.to_i
      @attach = attach || 'nil'
      @charset = charset
    end
    
    def response
      @response ||= QueryResponse.new(Net::HTTP.get(URI.parse("#{GATEWAY_URL}?#{params}")))
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

    private
    def params
      @params ||= generate_params
    end
    
    def generate_params
      "cmdno=2&date=#{@date}&bargainor_id=#{@spid}&transaction_id=#{transaction_id}&sp_billno=#{@order_id}&attach=#{@attach}&" +
      "output_xml=1&charset=#{@charset}&sign=#{sign}"
    end
    
    def generate_sign_params
      "attach=#{@attach}&bargainor_id=#{@spid}&charset=#{@charset}&cmdno=2&date=#{@date}&output_xml=1&" +
      "sp_billno=#{@order_id}&transaction_id=#{transaction_id}&key=#{@key}"
    end
  end
end