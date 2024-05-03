class IncomeSourcesController < ApplicationController
  respond_to :json
  before_action :process_token
  before_action :set_income_source, only: %i[show edit update destroy]

  # GET /categories
  def index
    @categories = IncomeSource.all
    render :json => @categories
  end

  # GET /categories/1
  def show
  end

  # GET /categories/new
  def new
    @income_source = IncomeSource.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    logger = Rails.logger
    @max_id = IncomeSource.where(owner: @current_user).pluck('max(income_source_id)').first()
    logger.info "id = #{@max_id}"

    if @max_id == nil
      @max_id = 0
    else
      @max_id = @max_id + 1
    end

    @income_source = IncomeSource.new(income_source_params)
    @income_source.income_source_id = @max_id
    @income_source.owner = @current_user

    if @income_source.save()
      render :json => { "result": @income_source, "status": 200 }
    else
      render :json => { "error": "failed to insert", "status": 400 }
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @income_source.update(income_source_params)
      render :json => { "result": 'IncomeSource was successfully updated.', "status": 200}
    else
      render :json => { "error": 'IncomeSource update failed.', "status": 400}
    end
  end

  # DELETE /categories/1
  def destroy
    @income_source.destroy
    render :json => { "result": 'IncomeSource was successfully destroyed.', "status": 200}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_source
      @income_source = IncomeSource.find(income_source_id: params[:id], owner: @current_user)
    end

    # Only allow a list of trusted parameters through.
    def income_source_params
      params.require(:IncomeSource).permit(:name, :income_freq_type)
    end

    def process_token
      logger = Rails.logger
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
