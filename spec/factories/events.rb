FactoryGirl.define do
  factory :event do
    name "Event name"
    category "foo"

    trait :in_london do
      name "In London"
      # coords of westminster
      latitude 51.4995
      longitude -0.1333
    end

    trait :in_croydon do
      name "In Croydon"
      # coords of croydon
      latitude 51.3727
      longitude -0.1099
    end

    trait :in_paris do
      name "In Paris"
      # coords of eiffel tower
      latitude 48.858222
      longitude 2.2945
    end

    trait :in_berlin do
      name "In Berlin"
      # coords of brandenburg gate
      latitude 52.516272
      longitude 13.377722 
    end
  end
end