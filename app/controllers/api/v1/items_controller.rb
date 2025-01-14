class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :item_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

  def index
    items = params[:sorted] == 'price' ? Item.all.order("unit_price asc") : Item.all

    if items.empty?
      render_error("No items found", :unprocessable_entity)
    else
      render json: ItemSerializer.new(items), status: :ok
    end
  end

  def show
    item = Item.find(params[:id]) 
    render json: ItemSerializer.new(item), status: :ok
  end

  def create
    new_item = Item.new(item_params)

    if new_item.save
      render json: ItemSerializer.new(new_item), status: :created
    else
      render_error(new_item.errors.full_messages.join(", "), :unprocessable_entity)
    end
  end

  def update
    item = Item.find(params[:id]) 

    if item.update(item_params)
      render json: ItemSerializer.new(item), status: :ok
    else
      render_error(item.errors.full_messages.join(", "), 400)
    end
  end

  def destroy
    item = Item.find(params[:id]) 
    item.destroy
    render json: { message: "Item deleted successfully" }, status: :no_content
  end

  def find_merchant
    # begin
    item = Item.find(params[:id]) 
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant), status: :ok

    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "Could not find Item with ID ##{params[:id]}."}, status: :not_found
    # end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def render_error(message, status)
    render json: { message: "Your query could not be completed", errors: [message] }, status: status
  end

  def item_not_found(exception)
    render_error("Item not found", :not_found)
  end

  def unprocessable_entity_error(exception)
    render_error("Unprocessable entity", :unprocessable_entity)
  end

end
   