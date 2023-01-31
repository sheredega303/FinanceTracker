class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    @tracked_stocks = current_user.stocks
    if !params[:show].nil?
      flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
      redirect_to my_portfolio_path
    else
      @user = current_user
      flash.now[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
      render turbo_stream:
               [turbo_stream.update("flash", partial: "layouts/messages"),
                turbo_stream.update("portfolio_stocks", partial: "stocks/list"),
                turbo_stream.update("result_frame", html: " ")]
    end
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock =  UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    @tracked_stocks = current_user.stocks
    @user = current_user
    flash.now[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    render turbo_stream:
             [turbo_stream.update("flash", partial: "layouts/messages"),
              turbo_stream.update("portfolio_stocks", partial: "stocks/list")]
  end
end
