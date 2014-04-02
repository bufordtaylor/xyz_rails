class Event < ActiveRecord::Base
  include PgSearch

  validates_presence_of :name, :latitude, :longitude

  scope :available, -> { where(available: true) }

  reverse_geocoded_by :latitude, :longitude
  
  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: {prefix: true}
                  }


end
