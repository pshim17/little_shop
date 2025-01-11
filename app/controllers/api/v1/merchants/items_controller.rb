class Api::V1::Merchants::ItemsController < ApplicationController
  begin
    def index
      merchant = Merchant.find(params[:id])
      items    = merchant.items
      render json: ItemSerializer.new(items)
    end
    rescue ActiveRecord::RecordNotFound
    end
end