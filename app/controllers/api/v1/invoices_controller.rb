class Api::V1::InvoicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :merchant_not_found_error_response

  def index
    merchant = Merchant.find(params[:merchant_id])
    invoices = merchant.invoices

    if params[:status]
      invoice_status = [];
      invoices.each do |invoice|
        if invoice.status == params[:status]
          invoice_status.push(invoice)
        end
      end
      render json: InvoiceSerializer.new(invoice_status)
    else
      render json: InvoiceSerializer.new(invoices)
    end
  end

  def merchant_not_found_error_response(error)
    render json: { error: "Merchant not found", message: error.message }, status: :not_found
  end
end