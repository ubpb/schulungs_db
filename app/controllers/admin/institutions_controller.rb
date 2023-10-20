class Admin::InstitutionsController < Admin::ApplicationController

  def index
    @institutions = Institution.order("position")
  end

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      @institution.move_to_bottom
      flash[:success] = t(".flash.success")
      redirect_to(admin_institutions_path)
    else
      render :new
    end
  end

  def edit
    @institution = Institution.find(params[:id])
  end

  def update
    @institution = Institution.find(params[:id])

    if @institution.update(institution_params)
      flash[:success] = t(".flash.success")
      redirect_to(admin_institutions_path)
    else
      render :edit
    end
  end

  def destroy
    @institution = Institution.find(params[:id])

    if @institution.destroy
      flash[:success] = t(".flash.success")
    else
      flash[:error] = t(".flash.error")
    end

    redirect_to(admin_institutions_path)
  end

  def reorder
    institutions = Institution.find(params[:new_order])

    institutions.each.with_index(1) do |institution, index|
      institution.update_column :position, index
    end

    head :ok
  end

private

  def institution_params
    params.require(:institution).permit(:title)
  end

end
