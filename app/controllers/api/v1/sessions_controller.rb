class Api::V1::SessionsController < Devise::SessionsController
  include ActionController::MimeResponds
  before_action :sign_in_params, only: [:create]
  before_action :load_user, only: [:create]
  before_action :verify_signed_out_user, only: [:destroy]
  before_action :generate_token, only: [:destroy]

  #sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in('user', @user)
      render json: {
        data: {
          user: @user
        }
      }
    else
      render json: {
        messages: 'Signed In Failed - Unauthorized'
      }
    end
  end

  # sign out
  def destroy
    user = User.find_by({id: params[:id]})
    user.authentication_token = @token
    user.save
    if user 
      render json: {
        message: 'Session destroyed'
      }
    else
      render json: {
        message: 'User not found'
      }
    end
  end


  private
  def sign_in_params
    params.require(:session).permit(:email, :password)
  end

  def verify_signed_out_user
    # é preciso utilizar esse método (vazio mesmo) antes do destroy
    # referencia: https://github.com/adamniedzielski/tiddle/issues/25 
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      throw(:warden, scope: :user)
    end
  end

  def generate_token
    @token = rand(36**20).to_s(36)
  end
end