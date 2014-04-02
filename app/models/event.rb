class Event < ActiveRecord::Base
  include PgSearch

  validates_presence_of :name, :latitude, :longitude

  scope :available, -> { where(available: true) }

  reverse_geocoded_by :latitude, :longitude
  
  pg_search_scope :search_by_name, against: :name, using: { tsearch: {prefix: true} }


  def public_attributes(with_similar_events: false, similar_events_radius: 20)
    hash = attributes.select do |key|
      %w(id name latitude longitude available distance bearing).include?(key)
    end

    if with_similar_events
      hash["similar"] = similar(radius: similar_events_radius).map(&:public_attributes)
    end

    hash
  end

  def similar(limit: 10, radius: 20)
    nearbys(radius).available.where(category: category).limit(limit)
  end

end
