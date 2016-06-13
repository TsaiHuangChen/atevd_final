class LotsController < ApplicationController
  before_action :set_lot,  :only => [ :show,
                                     :edit_normal_params,
                                     :update_normal_params,
                                     :edit_cliff_params,
                                     :update_cliff_params,
                                     :edit_site_difference_params,
                                     :update_site_difference_params,
				     :edit_continuously_fail_params,
                                     :update_continuously_fail_params,
                                     :destroy
                                  ]
  before_action :authenticate_user!,  only: [
                                        :new,
                                        :edit_normal_params,
                                        :update_normal_params,
                                        :edit_cliff_params,
                                        :update_cliff_params,
                                        :edit_site_difference_params,
                                        :update_site_difference_params,
                                        :destroy
                                            ]


  def index
    @lots = Lot.page(params[:page]).per(10).order('id DESC')
  end

  def new
    @lot = Lot.new
    @page_title = "new lot"
  end

  def create
    @lot = Lot.new(lot_params)
    if @lot.save
      #create the rows in site table
      for i in 0..(@lot.site_number-1) do
        @lot.sites.create( :site_serial => i )
      end

      if(@lot.generate_mode == 1)
        redirect_to :action => :edit_normal_params, :id => @lot
      elsif(@lot.generate_mode == 2)
        redirect_to :action => :edit_cliff_params, :id => @lot
      elsif(@lot.generate_mode == 3)
        redirect_to :action => :edit_site_difference_params, :id => @lot
      else
	redirect_to :action => :edit_continuously_fail_params, :id => @lot
      end
    else
      render :action => :new
    end
  end

  def edit_normal_params
    @page_title = "edit " + @lot.name
  end

  def update_normal_params
    if @lot.update(lot_params)
      redirect_to :controller => :lots, :action => :index
      flash[:notice] = "lot #{@lot.name} were succesfully created"
    else
      render :action => :edit_normal_params
    end
  end

  def edit_cliff_params
    @page_title = "edit " + @lot.name
  end

  def update_cliff_params
    if @lot.update(lot_params)
      redirect_to :controller => :lots, :action => :index
      flash[:notice] = "lot #{@lot.name} were succesfully created"
    else
      render :action => :edit_cliff_params
    end
  end

  def edit_site_difference_params
    @page_title = "edit " + @lot.name
  end

  def update_site_difference_params
    if @lot.update_attributes(lot_params)
      redirect_to :action => :index
      flash[:notice] = "lot #{@lot.name} were succesfully created"
    else
      render :action => :edit_site_difference_params
    end
  end

  def edit_continuously_fail_params
    @page_title = "edit " + @lot.name
  end

  def update_continuously_fail_params
    if @lot.update(lot_params)
      redirect_to :controller => :lots, :action => :index
      flash[:notice] = "lot #{@lot.name} were succesfully created"
    else
      render :action => :edit_continuously_fail_params
    end
  end


  def show
    @sites = Site.where( :lot_id => @lot )
    @page_title = @lot.name
  end

  def destroy
    #@lot = Lot.find(params[:id])
    @lot.destroy
    flash[:alert] = "lot were succesfully deleted"

    redirect_to :action => :index
  end

  private

  def lot_params
    params.require(:lot).permit(
      :name,
      :device_id,
      :tester,
      #:device,
      :total_device_count,
      :site_number,
      :generate_mode,
      :basic_yield,
      :cliff_number,
      :first_region_yield,
      :second_region_yield,
      sites_attributes: [ :lot_id, :site_serial, :site_enable, :site_yield, :id ]
    )
  end

  def set_lot
    @lot = Lot.find(params[:id])
  end

end
