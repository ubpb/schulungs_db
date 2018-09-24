class Admin::CategoriesController < Admin::ApplicationController

  def index
    @categories = Category.order("position")
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save && @category.move_to_bottom
      flash[:success] = t(".flash.success")
      redirect_to(admin_categories_path)
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      flash[:success] = t(".flash.success")
      redirect_to(admin_categories_path)
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:success] = t(".flash.success")
    else
      flash[:error] = t(".flash.error")
    end

    redirect_to(admin_categories_path)
  end

  def reorder
    categories = Category.find(params[:new_order])

    categories.each.with_index(1) do |category, index|
      category.update_column :position, index
    end

    head :ok
  end

private

  def category_params
    params.require(:category).permit(:title)
  end

end
