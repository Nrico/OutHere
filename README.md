# OutHere

OutHere is a prototype SwiftUI app that helps LGBTQ+ youth in rural areas connect socially. The main screen displays a map with glowing spots that represent recent activity. Tapping a spot reveals a card with more details.

This project is a Swift Package so that it can be opened in Xcode and built for iOS. Open the `Package.swift` file in Xcode to run the app.

## Features
- MapKit-based map view
- Search bar and filter icon overlay
- Mock data of spots with glowing activity indicators
- Sliding translucent card with spot information and quick actions

The app uses a simple MVVM structure and contains only local test data. It is intended as a lightweight prototype without external dependencies.

## Updates
- New `SpotLocation` model with activity levels
- Animated glow overlays scale with activity level on the map
- Toggle to filter spots active in the afternoon
- Soft connection modal surfaces nearby users with shared tags
- Experimental StandBy view showing glowing activity at followed spots
