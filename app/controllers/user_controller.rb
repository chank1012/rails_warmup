class UserController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
  end

  def index_error
    @error_code = params[:error].to_i
    error_msg_hash =
      {-1 => "The user name should be 5~20 characters long. Please try again.",
       -2 => "The password should be 8~20 characters long. Please try again.",
       -3 => "This user name already exists. Please try again.",
       -4 => "Invalid username and password combination. Please try again. "}
    @error_msg = error_msg_hash[@error_code]
  end

  def create
    if params[:login]
      login
    elsif params[:signup]
      signup
    else
      render nothing: true
      return
    end
    hash = JSON.parse @result
    if hash["error_code"] != nil
      @error_code = hash["error_code"]
      redirect_to :action => :index_error, :error => @error_code
    else
      @username = hash["user_name"]
      @count = hash["login_count"]
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
      @result = { error_code: err }.to_json
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

  def clear_data
    User.delete_all
  end


  # 3 API Renderer

  def render_signup
    signup
    render json: @result
  end

  def render_login
    login
    render json: @result
  end

  def render_clear_data
    clear_data
    render nothing: true
  end

private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
