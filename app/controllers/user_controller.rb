class UserController < ApplicationController
  def index
  end

  def index_error
    render index
  end

  def create
    if params[:login]
      login
      render json: @result
    else
      if params[:signup]
        signup
        render json: @result
      else
      end
    end
  end

  def show
  end

  def signup
    @user = User.new(user_params)
    if @user.save
      @result = { user_name: @user.username, login_count: @user.count }.to_json
    else
      @result = { error_code: -1 }.to_json
    end
  end

  def login
    begin
      @user = User.find(user_params)
      @user.increment!(:count)
      @result = { user_name: @user.username, login_count: @user.count }.to_json
    rescue ActiveRecord::RecordNotFound
      @result = { error_code: -1 }.to_json
      return
    end
  end

private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
