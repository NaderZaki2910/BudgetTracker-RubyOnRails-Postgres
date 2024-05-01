class WalletsController < ApplicationController
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
    logger.info "request = #{request.headers["HTTP_COOKIE"]}"
    @max_id = Wallet.where(owner: wallet_params[:owner]).pluck('max(wallet_id)').first()
    logger.info "id = #{@max_id}"

    if @max_id == nil
      @max_id = 0
    else
      @max_id = @max_id + 1
    end

    @wallet = Wallet.new(wallet_params)
    @wallet.wallet_id = @max_id

    if @wallet.save()
      render :json => { "result": @wallet, "status": 200 }
    else
      render :json => { "error": "failed to insert", "status": 400 }
    end
  end

  # PATCH/PUT /wallets/1
  def update
    if @wallet.update(wallet_params)
      redirect_to @wallet, notice: 'Wallet was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /wallets/1
  def destroy
    @wallet.destroy
    redirect_to wallets_url, notice: 'Wallet was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wallet_params
      params.require(:wallet).permit(:name, :description, :owner, :amount)
    end
end
