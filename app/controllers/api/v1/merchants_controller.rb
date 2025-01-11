class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:sorted] == "age"
      merchants = Merchant.order(created_at: :desc)
    elsif params[:status] == "returned"
      merchants = Merchant.joins(:invoices).where(invoices: {status: "returned"}).distinct
    elsif params[:count] == "true"
      merchants = Merchant.left_joins(:items).select("merchants.*, COUNT(items.id) AS item_count").group("merchants.id").order(id: :asc)                        
    else
      merchants = Merchant.all
    end
   render json: MerchantSerializer.new(merchants, { params: { count: params[:count] } })
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def create
    begin
      merchant = Merchant.create!(merchant_params)
      render json: MerchantSerializer.new(merchant), status: :created
    rescue
      render json: { error: "unprocessable entity" }, status: :unprocessable_entity
    end
  end

  def update
    begin
      merchant = Merchant.find(params[:id])
      if params[:name]
        merchant.update!(merchant_params) 
        render json: MerchantSerializer.new(merchant), status: :ok
      else
        render json: { error: "unprocessable entity" }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(exception), status: :not_found
    end
  end

  def destroy
    begin
      merchant = Merchant.find(params[:id])
      merchant.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(exception), status: :not_found
    end
  end

  private

  def merchant_params
    params.permit(:name)
  end
end