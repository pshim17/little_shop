class Api::V1::MerchantsController < ApplicationController
  def index
   merchants = Merchant.all

   render json: { data: merchants }
  end
end