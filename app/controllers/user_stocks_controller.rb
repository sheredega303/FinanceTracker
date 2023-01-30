class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    @tracked_stocks = current_user.stocks
    flash.now[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    render turbo_stream:
             [turbo_stream.update("flash", partial: "layouts/messages"),
              turbo_stream.update("portfolio_stocks", partial: "stocks/list"),
              turbo_stream.update("result_frame", html: " ")]
  end
end
