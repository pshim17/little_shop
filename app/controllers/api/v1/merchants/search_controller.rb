class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merch = Merchant.find_by_name(params[:name])
    render json: MerchantSerializer.new(merch)
    # require'pry';binding.pry
  end
end