class CategoriesController < ApplicationController
  before_action :set_Category, only: %i[show edit update destroy]

  # GET /categories
  def index
    @categories = Category.all
    render :json => @categories
  end

  # GET /categories/1
  def show
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
    logger.info "request = #{request.headers["HTTP_COOKIE"]}"
    @max_id = Category.where(owner: category_params[:owner]).pluck('max(category_id)').first()
    logger.info "id = #{@max_id}"

    if @max_id == nil
      @max_id = 0
    else
      @max_id = @max_id + 1
    end

    @category = Category.new(category_params)
    @category.category_id = @max_id

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
    def set_Category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:Category).permit(:name, :child_of, :owner)
    end
end
