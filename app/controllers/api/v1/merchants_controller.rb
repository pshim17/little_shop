class Api::V1::MerchantsController < ApplicationController
  def index
   merchants = Merchant.all

   render json: { data: merchants }
  end

  def create
    begin
      merchant = Merchant.create!(merchant_params)
      render json: MerchantSerializer.new(merchant), status: :created #201
    rescue
      render json: {error: "unprocessable entity"}, status: :unprocessable_entity #422
    end
  end

  private

  def merchant_params
    params.permit(:name)
  end
end