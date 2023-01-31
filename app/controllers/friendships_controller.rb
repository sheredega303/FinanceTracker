class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)

    if !params[:show].nil?
      if current_user.save
        flash[:notice] = "Following to #{friend.email}"
      else
        flash[:alert] = "There was something wrong with the tracking request"
      end
      redirect_to my_friends_path
    else
      if current_user.save
        flash.now[:notice] = "Following to #{friend.email}"
      else
        flash.now[:alert] = "There was something wrong with the tracking request"
      end
      @friends = current_user.friends
      @new_friends = User.find(params[:search])
      render turbo_stream:
               [turbo_stream.update("flash", partial: "layouts/messages"),
                turbo_stream.update("user_friends", partial: "friends/list"),
                turbo_stream.update("search_friend", partial: "friends/search")]
    end
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    @friends = current_user.friends
    flash.now[:notice] = "Stopped following"
    render turbo_stream:
             [turbo_stream.update("flash", partial: "layouts/messages"),
              turbo_stream.update("user_friends", partial: "friends/list")]
  end

end
