class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

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
    merchant = Merchant.find(params[:id])
    if params[:name]
      merchant.update!(merchant_params)
      render json: MerchantSerializer.new(merchant), status: :ok
    else
      render json: { error: "unprocessable entity" }, status: :unprocessable_entity
    end
  end

  def destroy
    merchant = Merchant.find(params[:id])
    merchant.destroy
    head :no_content
  end

  private

  def merchant_params
    params.permit(:name)
  end

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end