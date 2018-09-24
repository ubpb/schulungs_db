class Admin::TargetAudiencesController < Admin::ApplicationController

  def index
    @target_audiences = TargetAudience.order("position")
  end

  def new
    @target_audience = TargetAudience.new
  end

  def create
    @target_audience = TargetAudience.new(target_audience_params)

    if @target_audience.save && @target_audience.move_to_bottom
      flash[:success] = t(".flash.success")
      redirect_to(admin_target_audiences_path)
    else
      render :new
    end
  end

  def edit
    @target_audience = TargetAudience.find(params[:id])
  end

  def update
    @target_audience = TargetAudience.find(params[:id])

    if @target_audience.update_attributes(target_audience_params)
      flash[:success] = t(".flash.success")
      redirect_to(admin_target_audiences_path)
    else
      render :edit
    end
  end

  def destroy
    @target_audience = TargetAudience.find(params[:id])

    if @target_audience.destroy
      flash[:success] = t(".flash.success")
    else
      flash[:error] = t(".flash.error")
    end

    redirect_to(admin_target_audiences_path)
  end

  def reorder
    target_audiences = TargetAudience.find(params[:new_order])

    target_audiences.each.with_index(1) do |target_audience, index|
      target_audience.update_column :position, index
    end

    head :ok
  end

private

  def target_audience_params
    params.require(:target_audience).permit(:title)
  end

end
