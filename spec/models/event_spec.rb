require 'spec_helper'

describe Event do

  describe "listing neighboring events" do
    before :all do
      @event_london = create(:event, :in_london, available: true)
      @event_paris = create(:event, :in_paris, available: false)
      @event_berlin = create(:event, :in_berlin, available: true)
    end

    it "should respect the distances" do
      # paris <-> london => 342km
      expect(@event_paris.nearbys(400).to_a).to eql([@event_london])
      
      # paris <-> berlin => 878km
      expect(@event_paris.nearbys(900).to_a).to eql([@event_london, @event_berlin])
    end

    it "should respect the scopes" do
      # paris is unavailable
      
      expect(@event_london.nearbys(1000).available.to_a).to eql([@event_berlin])
    end
  end
end
