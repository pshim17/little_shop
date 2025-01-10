class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: { data: merchants }
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