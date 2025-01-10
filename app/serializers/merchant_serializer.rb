class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  attributes :item_count, if: Proc.new { |merchant, params|
    params[:count] == "true"
  }
end