class DevicesController < ApplicationController
  #before_action :set_device, :only => [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @devices = Device.page(params[:page]).per(10)
  end

  def new
    @device = Device.new
    @page_title = "new device"
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      redirect_to :action => :index
      flash[:notice] = "detection rules were succesfully created"
    else
      render :action => :new
    end
  end

  def show
    @device = Device.find(params[:id])
    @page_title = @device.name
  end

  def edit
    @device = Device.find(params[:id])
    @page_title = "edit " + @device.name
  end

  def update
    @device = Device.find(params[:id])
    if @device.update(device_params)
      redirect_to :action => :show, :id => @device
      flash[:notice] = "detection rules were succesfully updated"
    else
      render :action => :edit
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy
    flash[:alert] = "detection rules were succesfully deleted"

    redirect_to :action => :index
  end

  private

  def device_params
    params.require(:device).permit(
        :name,
        :site_difference_detect_enable,
        :site_difference_detect_window,
        :site_difference_detect_threshold,
        :continuously_failure_detect_enable,
        :continuously_failure_detect_threshold,
        :time_variance_detect_enable,
        :time_variance_detect_window_small,
        :time_variance_detect_window_large,
        :time_variance_detect_threshold,
        :different_tester_variance_detect_enable,
        :different_tester_variance_detect_window,
        :different_tester_variance_detect_threshold
    )
  end

  def set_device
    @device = Device.find(params[:id])
  end

end
