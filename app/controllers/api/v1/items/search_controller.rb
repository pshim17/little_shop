class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name] && (params[:min_price] || params[:max_price])
      return render json: { errors: "Cannot send both name and min_price or max_price parameters"  }, status: 400
    elsif (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
      return render json: { errors: "min_price/max_price cannot be less than 0"  }, status: 400
    end

    if params[:name]
      items = Item.find_by_name(params[:name])
    elsif params[:min_price]
      items = Item.find_by_price(params[:min_price], :min_price)
    elsif params[:max_price]
      items = Item.find_by_price(params[:max_price], :max_price)
    end
    render json: ItemSerializer.new(items)
  end
end
