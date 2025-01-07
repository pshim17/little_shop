class Api::V1::ItemsController < ApplicationController
  def index
    if params[:sorted] === 'price'
      items = Item.all.order("unit_price asc")
    else 
      items = Item.all
    end

    itemsFormatted = items.map do |item|
      {
        id: item.id.to_s,
        type: "item",
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id
        }
      }
    end
    render json: { data: itemsFormatted }
  end
end