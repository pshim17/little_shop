class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name]
      items = Item.find_by_name(params[:name])
    end
    render json: ItemSerializer.new(items)
  end
end
