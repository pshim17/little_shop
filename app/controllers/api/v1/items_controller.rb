class Api::V1::ItemsController < ApplicationController
  def index
    if params[:sorted] == 'price'
      items = Item.all.order("unit_price asc")
    else
      items = Item.all
    end

    if items.empty?
      render json: {
        message: "Your query could not be completed",
        errors: ["No items found"]
      }, status: :unprocessable_entity
    else
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

  def show
    item = Item.find_by(id: params[:id])

    if item.nil?
      render json: {
        message: "Your query could not be completed",
        errors: ["Item not found"]
      }, status: :not_found
    else
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
      }
    end
  end

  def create
    new_item = Item.new(item_params)

    if new_item.save
      render json: {
        data: {
          id: new_item.id.to_s,
          type: "item",
          attributes: {
            name: new_item.name,
            description: new_item.description,
            unit_price: new_item.unit_price,
            merchant_id: new_item.merchant_id
          }
        }
      }, status: :created
    else
      render json: {
        message: "Your query could not be completed",
        errors: new_item.errors.full_messages
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
    item = Item.find_by(id: params[:id])

    if item
      item.destroy
      render json: { message: "Item deleted successfully" }, status: :no_content
    else
      render json: {
        message: "Your query could not be completed",
        errors: ["Item not found"]
      }, status: :not_found
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
