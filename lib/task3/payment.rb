module Task3
  # Payment is database object that contains current payment status, amount,
  # any information received from vendor
  class Payment < ActiveRecord::Base
    # Payment is connected to corresponding order that should contain all
    # information required to create a payment: amount, user email, user
    # address; method should return vendor id which can be used with
    # #find_by_vendor_id to find the payment
    def self.make(_order)
      raise NotImplementedError
    end

    # Method should return a concrete vendor Payment instance and should be
    # used on checkout completion page
    def self.find_by_vendor_id(_id)
      raise NotImplementedError
    end

    # Method should return a url where user should be directed in order to make
    # actual payment
    def checkout_url
      raise NotImplementedError
    end

    # Method should receive payment status from vendor
    # - In case of success, order#payment_received should be called
    # - This method can be executed more than once to serve different vendor
    #   payment status needs (preparing, processing, received and etc.)
    # - order#payment_received should be called only once
    # - Method should be executed at the order completion page or via
    #   cron-script to process those payments which status were not received by
    #   visiting order completion page due to connection errors or other
    #   circumstances
    def complete
      raise NotImplementedError
    end
  end
end
