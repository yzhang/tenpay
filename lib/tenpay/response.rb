require 'digest/md5'
require 'cgi'
require 'iconv'

module Tenpay
  class Response
    attr_reader :order_id, :total_fee, :attach, :pay_time
    
    def initialize(params)
      @cmdno = params[:cmdno] || ''
      @date = params[:date] || ''
      @fee_type = params[:fee_type] || ''
      @pay_info = params[:pay_info] || ''
      @pay_result = params[:pay_result] || ''
      @pay_time = Time.at((params[:pay_time] || '0').to_i)
      @sign = params[:sign] || ''
      @order_id = (params[:sp_billno] || '').to_i
      @transaction_id = params[:transaction_id] || ''
      @total_fee = params[:total_fee] || ''
      @attach = params[:attach] || ''
      
      @spid = Tenpay::Config.spid
      @key = Tenpay::Config.key
    end
    
    def successful?
      @pay_info == 'OK' && @pay_result == '0' && valid_sign?
    end
    
    def valid_sign?
      @sign == Digest::MD5.hexdigest(sign_params).upcase
    end
    
    private
    def sign_params
      @sign_params ||= "cmdno=#{@cmdno}&pay_result=#{@pay_result}&date=#{@date}&transaction_id=#{@transaction_id}" +
                "&sp_billno=#{@order_id}&total_fee=#{@total_fee}&fee_type=#{@fee_type}" +
                "&attach=#{CGI.escape(@attach)}&key=#{@key}"
    end
  end
end