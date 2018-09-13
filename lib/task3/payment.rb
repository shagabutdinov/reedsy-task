module Task3
  # Payment is database object that contains current payment status, amount,
  # any information received from vendor; I provided implementation expected by
  # default by interviewers, but in service-oriented architechture I propose to
  # create separate service with methods listed below to decouple validations &
  # relations logic from business logic (make model thin)
  #
  # Usage:
  #
  # def pay_order
  #   # create the payment and redirect user to payment page
  #   # params[:id] should contain order id
  #   redirect_to Payment::Stripe.make(Order.find(params[:id]))
  # end
  #
  # def process_order
  #   # params[:id] should contain vendor payment id
  #   payment = Payment::Stripe.find_by_vendor_id(params[:id])
  #   payment.complete
  #   if payment.success?
  #     redirect_to payment_received_path
  #   else
  #     redirect_to payment_failed_path
  #   end
  # end
  class Payment < ActiveRecord::Base
    # Payment is connected to corresponding order that should contain all
    # information required to create a payment: amount, user email, user
    # address; method should return vendor id which can be used with
    # #find_by_vendor_id to find the payment
    def self.make(order)
      raise NotImplementedError
    end

    # Method should return a concrete vendor Payment instance and should be
    # used on checkout completion page
    def self.find_by_vendor_id(id)
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