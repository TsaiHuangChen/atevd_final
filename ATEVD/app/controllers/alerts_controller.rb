class AlertsController < ApplicationController

  before_action :authenticate_user!, only: [:destroy]

  def index
    @alerts = Alert.page(params[:page]).per(20).order('id DESC')
  end

  def show
    @alert = Alert.find(params[:id])
  end

  def edit
    #@alert = Alert.find(params[:id])
  end

  def update
    #@alert = Alert.find(params[:id])
  end

  def destroy
    @alert = Alert.find(params[:id])
    #set lot detect flag to false
    a = @alert.lot
    if(@alert.alerts_kind == 1)
      a.site_difference_detected = false
    elsif(@alert.alerts_kind == 2)
      a.continuously_failure_detected = false
    elsif(@alert.alerts_kind == 3)
      a.time_variance_detected = false
    else
      Lot.find_each do |b|
        if(b.name == a.name)
          b.different_tester_variance_detected = false
          b.save
        end
      end
      a.different_tester_variance_detected = false
    end
    a.save

    @alert.destroy
    flash[:alert] = "Alert record was succesfully deleted"

    redirect_to :action => :index
  end
  private
end
