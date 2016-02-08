class OffersController < ApplicationController


  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params[:offer])
    @offer.valid?
    if  @offer.valid?
      @offers =  Offer.get_offers(params[:offer])
      @offers = @offers["offers"]
    end
    if not @offers.blank?
      if @offers != "invalid_response"
        flash[:notice] = nil
        render :show, :offers => @offers
      else
        flash[:notice] = nil     
        flash[:alert] = "Invalid response got from server"
        render new_offer_path
      end
    elsif not @offer.valid?
      flash[:notice] = nil
      render new_offer_path
    else
      flash.now[:notice] = "No offers available"
      render new_offer_path 
    end  
  end

  def show

  end

end
