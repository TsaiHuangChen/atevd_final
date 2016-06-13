class DataController < ApplicationController

  def index
    @lots = Lot.page(params[:page]).per(10)
  end

  def show
    @lot = Lot.find(params[:id])
    @data = Datum.where( :lot_id => @lot ).order('id DESC').limit(100)
    passed = Datum.where( :lot_id => @lot, :bin => 1 ).count
    total = Datum.where( :lot_id => @lot ).count
    @yield = (passed.to_f / total.to_f)*100
  end

  def show_full
    @lot = Lot.find(params[:id])
    @data = Datum.where( :lot_id => @lot ).order('id DESC').page(params[:page]).per(100)
    passed = Datum.where( :lot_id => @lot, :bin => 1 ).count
    total = Datum.where( :lot_id => @lot ).count
    @yield = (passed.to_f / total.to_f)*100
  end
end
