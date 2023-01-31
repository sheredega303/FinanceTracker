class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    if params[:friend].present?
      @new_friends = User.search(params[:friend])
      @new_friends = current_user.except_current_user(@new_friends)
      if !@new_friends.empty?
        render turbo_stream: turbo_stream.update("search_friend", partial: "friends/search")
      else
        flash.now[:alert] = "Couldn't find user"
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/messages")
      end
    else
      flash.now[:alert] = "Please enter a friend name or email to search"
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/messages")
    end
  end

end
