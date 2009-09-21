module Tenpay
  class QueryResponse
    def initialize(response)
      @body = response
    end
  
    def valid?
      sign == Digest::MD5.hexdigest(sign_params).upcase
    end
    
    def successful?
      valid? && pay_result == '0'
    end
  
    def doc
      @doc ||= Hpricot(@body)
    end

    def attach
      @attach ||= (doc / 'attach').inner_text
    end
  
    def cmdno
      @cmdno ||= (doc / 'cmdno').inner_text
    end
  
    def date
      @date  ||= (doc / 'date').inner_text
    end

    def fee_type
      @fee_type ||= (doc / 'fee_type').inner_text
    end
  
    def pay_info
      @pay_info ||= (doc / 'pay_info').inner_text
    end

    def pay_result
      @pay_result ||= (doc / 'pay_result').inner_text
    end

    def order_id
      @order_id ||= (doc / 'sp_billno').inner_text
    end
  
    def total_fee
      @total_fee ||= (doc / 'total_fee').inner_text
    end
    
    def transaction_id
      @transaction_id ||= (doc / 'transaction_id').inner_text
    end
  
    def sign
      @sign ||= (doc / 'sign').inner_text
    end
  private
    def sign_params
      "attach=#{attach}&bargainor_id=#{Tenpay::Config.spid}&cmdno=#{cmdno}&date=#{date}&fee_type=#{fee_type}" +
      "&pay_info=#{pay_info}&pay_result=#{pay_result}&sp_billno=#{order_id}&total_fee=#{total_fee}&" +
      "transaction_id=#{transaction_id}&key=#{Tenpay::Config.key}"
    end
  end
end