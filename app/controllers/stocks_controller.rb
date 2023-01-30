class StocksController < ApplicationController

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock

      else
        flash.now[:alert] = "Please enter a valid symbol to search"
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/messages")
      end
    else
      flash.now[:alert] = "Please enter a symbol to search"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/messages")
    end
  end
end
