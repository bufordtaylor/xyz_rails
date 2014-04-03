class Admin::EventsController < Admin::AdminController
  before_action :select_event, only: [:edit, :update, :destroy]

  def index
    @events = Event.order("id desc")
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      flash[:notice] = "Event created"
      redirect_to action: "index"
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      flash[:notice] = "Event updated"
      redirect_to action: "index"
    else
      render action: "edit"
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event deleted"
    
    redirect_to action: "index"
  end

  private
  def select_event
    @event = Event.find(params[:id])
  end

  def event_params
    params[:event].permit(:name, :latitude, :longitude, :available, :category)
  end

end
