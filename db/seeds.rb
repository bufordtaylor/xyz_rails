DatabaseCleaner.clean_with :truncation
DatabaseCleaner.clean

### EVENTS
puts "Creating the events..."
events_attrs = [
  {name: "TechCrunch 50", category: "tech", latitude: 51.501000, longitude: -0.142000, available: true},
  {name: "WWDC", category: "tech", latitude: 51.523778, longitude: -0.205500, available: true},
  {name: "Fight Club", category: "cinema", latitude: 51.504444, longitude: -0.086667, available: true},
  {name: "Matrix", category: "cinema", latitude: 51.538333, longitude: -0.013333, available: true},
  {name: "Google I/O", category: "tech", latitude: 50.066944, longitude: -5.746944, available: true}
]
Event.create!(events_attrs)

puts "Done!"
