class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.find_by_name(params[:name])
  end
end