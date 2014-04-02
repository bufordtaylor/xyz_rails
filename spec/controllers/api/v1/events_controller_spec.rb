require 'spec_helper'

describe Api::V1::EventsController do

  describe "searching" do

    before do
      @event_london = create(:event, :in_london, available: true)
      @event_paris = create(:event, :in_paris, available: false)
      @event_berlin = create(:event, :in_berlin, available: true)
    end

    context "with partial text" do
      before do
        @event_croydon = create(:event, :in_croydon, available: true)

        get "search", q: "lon"
        @resp = JSON.parse(@response.body)

        expect(@response.status).to eql(200)
        expect(@resp["status"]).to eql("success")
      end

      it "auto-completes the events" do
        expect(@resp["events"].is_a?(Array)).to be true

        expect(@resp["events"].size).to eql(1)

        expect(@resp["events"][0]).to eql({
          "id" => @event_london.id,
          "name" => @event_london.name,
          "latitude" => @event_london.latitude,
          "longitude" => @event_london.longitude,
          "available" => @event_london.available,
          "similar" => [
            {
              "id" => @event_croydon.id,
              "name" => @event_croydon.name,
              "available" => @event_croydon.available,
              "latitude" => @event_croydon.latitude,
              "longitude" => @event_croydon.longitude,
              "distance" => 14.1925101046509,
              "bearing" => "169.544124495522"
            }
          ]
        })
      end
    end

  end # searching

  describe "showing" do
    before do
      @event_london = create(:event, :in_london, available: true)
    end

    context "with a valid id" do
      before do
        get "show", id: @event_london.id
        @resp = JSON.parse(@response.body)

        expect(@response.status).to eql(200)
        expect(@resp["status"]).to eql("success")
      end

      it "returns the expected event" do
        expect(@resp["event"].is_a?(Hash)).to be true

        expect(@resp["event"]).to eql({
          "id" => @event_london.id,
          "name" => @event_london.name,
          "latitude" => @event_london.latitude,
          "longitude" => @event_london.longitude,
          "available" => @event_london.available,
          "similar" => []
        })

      end
    end
  end

end
