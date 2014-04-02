class Api::V1::EventsController < Api::V1::ApiController

  def search
    events = Event.search_by_name(params[:q]).limit(30)
    events_hashes = events.map{|event| event.public_attributes(with_similar_events: true) }

    render_api_success(events: events_hashes)
  end

  def show
    event = Event.find_by_id(params[:id])
    event_hash = event.public_attributes(with_similar_events: true)
    
    render_api_success(event: event_hash)
  end

end
