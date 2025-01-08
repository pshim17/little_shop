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

  def show
    item = Item.find(params[:id])
  
    render json: {
      data:
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
    }
  end

  def create
    newItem = Item.new(item_params)
  
    if newItem.save
      render json: {
        data: {
          id: newItem.id.to_s,
          type: "item",
          attributes: {
            name: newItem.name,
            description: newItem.description,
            unit_price: newItem.unit_price,
            merchant_id: newItem.merchant_id
          }
        }
      }, status: :created
    else
      render json: {
        errors: newItem.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find_by(id: params[:id])
    
    if item.nil?
      render json: { errors: [{ status: "404", message: "Item not found" }] }, status: :not_found
    elsif item.update(item_params)
      render json: {
        data: {
          id: item.id.to_s,
          type: "item",
          attributes: {
            name: item.name,
            description: item.description,
            unit_price: item.unit_price,
            merchant_id: item.merchant_id
          }
        }
      }, status: :ok
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end