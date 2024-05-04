class CategoriesController < ApplicationController
  respond_to :json
  before_action :process_token
  before_action :set_category, only: %i[show edit update destroy]

  # GET /categories
  def index
    @categories = Category.all
    render :json => @categories
  end

  # GET /categories/1
  def show
    render :json => @category
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    logger = Rails.logger
    @max_id = Category.where(owner: @current_user).pluck('max(category_id)').first()
    logger.info "id = #{@max_id}"

    if @max_id == nil
      @max_id = 0
    else
      @max_id = @max_id + 1
    end

    @category = Category.new(category_params)
    @category.category_id = @max_id
    @category.owner = @current_user

    if @category.save()
      render :json => { "result": @category, "status": 200 }
    else
      render :json => { "error": "failed to insert", "status": 400 }
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render :json => { "result": 'Category was successfully updated.', "status": 200}
    else
      render :json => { "error": 'Category update failed.', "status": 400}
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    render :json => { "result": 'Category was successfully destroyed.', "status": 200}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(category_id: params[:category_id], owner: @current_user)
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :child_of)
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
