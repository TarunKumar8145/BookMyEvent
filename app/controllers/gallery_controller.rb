class GalleryController < ApplicationController
  def index
    if params[:query].present?
      @events = Event.where("event_name LIKE ? OR location LIKE ? OR venue LIKE ? OR date LIKE ? OR category LIKE ? ",
                            "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
                     .paginate(page: params[:page], per_page: 9)  # Add Pagination Here
    else
      @events = Event.paginate(page: params[:page], per_page: 9)  # Add Pagination Here
    end
  end
end
