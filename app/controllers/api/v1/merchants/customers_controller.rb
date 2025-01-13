class Api::V1::Merchants::CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :item_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

  def index
    customers = Customer.all
    formatted_customers = customers.map do |customer|
      {
        id: customer.id.to_s,
        type: "customer",
        attributes: {
          first_name: customer.first_name,
          last_name: customer.last_name
        }
      }
    end
    render json: { data: formatted_customers }, status: :ok
    
  end

  def customers_by_merchant
    merchant_id = params[:merchant_id]
    merchant = Merchant.find_by(id: params[:merchant_id])
    

    if merchant.nil?
      render json: { error: "Merchant ID# #{merchant_id} not found."}, status: :not_found
      return
    end

    customers = Customer.joins(:invoices).where(invoices: {merchant_id: merchant_id})
    
    if customers.empty?
      render json: { data: []}, status: :ok
      return
    end

    formatted_customers = customers.map do |customer|
      {
        id: customer.id.to_s,
        type: "customer",
        attributes: {
          first_name: customer.first_name,
          last_name: customer.last_name
        }
      }
    end

    render json: { data: formatted_customers }, status: :ok
  end

end
