class WalletsController < ApplicationController
  respond_to :json
  before_action :process_token
  before_action :set_wallet, only: %i[show edit update destroy]

  # GET /wallets
  def index
    @wallets = Wallet.all
    render :json => @wallets
  end

  # GET /wallets/1
  def show
  end

  # GET /wallets/new
  def new
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit
  end

  # POST /wallets
  def create
    logger = Rails.logger
    if @current_user != nil
      @max_id = Wallet.where(owner: @current_user).pluck('max(wallet_id)').first()
      logger.info "id = #{@max_id}"

      if @max_id == nil
        @max_id = 0
      else
        @max_id = @max_id + 1
      end

      @wallet = Wallet.new(wallet_params)
      @wallet.wallet_id = @max_id
      @wallet.owner = @current_user

      if @wallet.save()
        render :json => { "result": @wallet, "status": 200 }
      else
        render :json => { "error": "failed to insert", "status": 400 }
      end
    end
  end

  # PATCH/PUT /wallets/1
  def update
    if @wallet.update(wallet_params)
      render :json => { 'message': 'Wallet was successfully updated.', "status": 200 }
    else
      render :json => { 'message': 'Wallet update failed.', "status": 400 }
    end
  end

  # DELETE /wallets/1
  def destroy
    @wallet.destroy
    render :json => { 'message': 'Wallet was successfully destroyed.', "status": 200 }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(wallet_id: params[:wallet_id], owner: @current_user)
    end

    # Only allow a list of trusted parameters through.
    def wallet_params
      params.require(:wallet).permit(:name, :description, :amount)
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
