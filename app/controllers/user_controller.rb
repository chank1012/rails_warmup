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

  def get_error_code
    if @user.errors.any?
      @user.errors.details[:username].each do |e|
        return -1 if e[:error] == :invalid_length
      end
      @user.errors.details[:password].each do |e|
        return -2 if e[:error] == :invalid_length
      end
      @user.errors.details[:username].each do |e|
        return -3 if e[:error] == :taken
      end
    end
    return 0
  end

  def signup
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      @result = { user_name: @user.username, login_count: @user.count }.to_json
    else
      err = get_error_code
      @result = { error_code: err }
    end
  end

  def login
    @user = User.find_by(user_params)
    if @user != nil
      @user.increment!(:count)
      @result = { user_name: @user.username, login_count: @user.count }.to_json
    else
      @result = { error_code: -4 }.to_json
    end
  end

  def clearData
    User.all.destroy
  end

private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
