class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:name].blank?
      return render json: { message: "Name parameter is blank" }, status: :bad_request
    end
    
    merch = Merchant.find_by_name(params[:name])
    
    if merch
      render json: MerchantSerializer.new(merch)
    else
      render json: { data: MerchantSerializer.new(merch), message: "Merchant not found" }, status: :not_found
    end  
  end
end