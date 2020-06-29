class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def add_friend
    friendship = current_user.friendships.build(friend_id: params[:id], confirmed: false)
    flash[:notice] = if friendship.save
                       'Friends request has been sent'
                     else
                       'Error occured during sending request please try again'
                     end
    redirect_to users_path
  end

  def accepts_friend
    mutal = current_user.inverse_friendships.find_by(user_id: params[:id])
    mutal.confirmed = true
    flash[:notice] = if mutal.save
                       'You have been accepted friendship'
                     else
                       'Error occuredto accept please try again'
                     end
    redirect_to users_path
  end
end
