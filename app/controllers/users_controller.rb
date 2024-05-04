class UsersController < ApplicationController
  respond_to :json
  before_action :process_token
  before_action :set_user, only: %i[destroy]

  # GET /user
  def index
    render :json => User.where(email: @current_user).select(:name, :email, :image).first
  end

  # DELETE /users
  def destroy
    @user.destroy
    render :json => { 'message': 'User was successfully destroyed.', "status": 200 }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(email: @current_user)
    end

    def process_token
      logger = Rails.logger
      logger.info "payload = #{request.headers['authorization']}"
      if request.headers['Authorization'].present?
        begin
          jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1].remove('"'), Rails.application.credentials.devise_jwt_secret_key).first
          logger.info "payload = #{jwt_payload}"
          logger.info "current_user = #{jwt_payload['sub']}"
          @current_user = jwt_payload['sub']
        rescue JWT::VerificationError, JWT::DecodeError
          render :json => {"message": :unauthorized, "status": 401}
        end
      end
    end
end
