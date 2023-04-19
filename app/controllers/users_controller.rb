class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @prototypes = current_user.prototypes
  end  
end
