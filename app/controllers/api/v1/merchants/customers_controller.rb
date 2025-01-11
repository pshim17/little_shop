class Api::V1::Merchants::CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :item_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

  def index
    customers = Customer.joins(:invoices) 
    # binding.pry
    render json: customers.to_json
  end

  # def index
  #   merchant_id = params[:merchant_id]
  #   customers = Customer.joins(:invoices).where(invoices: {merchant_id: merchant_id})
  #   binding.pry
  #   render json: customers.to_json
  # end

  def customers_by_merchant
    begin
      merchant_id = params[:merchant_id]
      customers = Customer.joins(:invoices).where(invoices: {merchant_id: merchant_id})
      
      formatted_customers = customers.map do |customer|
        {
          id: customer_id.to_s,
          type: "customer"
          attributes: {
            first_name: customer.first_name,
            last_name: customer.last_name
          }
        }
      end

      render json: { data: formatted_customers }, status: :ok

    rescue ActiveRecord::RecordNotFound  
      render json: { error: "Merchant ID not found."}, status: :not_found
    end
  end

end
