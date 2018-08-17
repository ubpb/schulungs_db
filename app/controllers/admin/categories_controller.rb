class Admin::CategoriesController < Admin::ApplicationController

  def index
    @categories = Category.order("title")
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
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

private

  def category_params
    params.require(:category).permit(:title)
  end

end
