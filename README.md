# OutHere

OutHere is a prototype SwiftUI app that helps LGBTQ+ youth in rural areas connect socially. The main screen displays a map with glowing spots that represent recent activity. Tapping a spot reveals a card with more details.

This project is a Swift Package so that it can be opened in Xcode and built for iOS. Open the `Package.swift` file in Xcode to run the app.

## Features
- MapKit-based map view
- Search bar and filter icon overlay
- Real-time Firestore spots with glowing activity indicators
- Sliding translucent card with spot information and quick actions

The app uses a simple MVVM structure. It now integrates with **Firebase** for real‑time spot and presence syncing across devices.

## Updates
- New `SpotLocation` model with activity levels
- Animated glow overlays scale with activity level on the map
- Toggle to filter spots active in the afternoon
- Soft connection modal surfaces nearby users with shared tags
- Experimental StandBy view showing glowing activity at followed spots
- Safety options to report, block, mute or set safe hours
- Firebase-backed spot and presence syncing across devices

## Function and Feature Overview

### Models
- **SpotLocation**: Represents a place on the map with a name, coordinates, tags and popularity level. Includes a helper initializer to load from Firestore documents.
- **SpotEvent**: Describes an event happening at a spot with title, date and tags. Sample events are provided as `mockData`.
- **UserProfile**: Stores the current user's nickname, pronouns, interests and followed spots. Also tracks the chosen presence mode and connection frequency.
- **UserPresence**: Enum describing visibility options (`visible`, `anonymous`, `invisible`).
- **UserSafetySettings**: Persists blocked or muted spots and safe hours when presence should be hidden.

### View Models
- **SpotViewModel**: Loads spots from Firebase (or mock data), keeps track of presence counts and active spots, and provides helper methods such as `checkIn` and `connectionContext`.
- **SafetyViewModel**: Manages `UserSafetySettings`, letting the user block, mute or report content and check whether the current time is within a safe hour range.

### Services
- **FirebaseService**: Wraps Firebase configuration. Provides methods to observe spots, check in at a spot, and observe presence counts in real time.

### Views
- **ContentView**: The main screen combining `SpotMapView`, search bar and toolbar actions. Presents sheets for the profile, events, followed spots and the experimental StandBy view.
- **SpotMapView**: Displays spots on a `Map` with glowing annotations that scale with activity. Supports filtering to show all, matched or followed spots.
- **SpotDetailCard**: Shown when tapping a spot. Lets the user check in with a presence mode, follow/unfollow and send quick reactions.
- **SpotCardView**: A compact card used in lists such as the followed spots screen.
- **EventBoardView** and **EventCardView**: List upcoming `SpotEvent`s and allow users to mark interest or access safety options.
- **ProfileView** and **OnboardingView**: Edit and display the user's profile details, presence settings and interests.
- **SafetyOptionsView**: Offers actions to report, block or mute content and set safe hours. Includes `SafeHoursView` and `ReportContentView` helpers.
- **StandByView**: An ambient full‑screen display cycling through followed spots and their activity levels.
- **ConnectionModalView**: Appears after checking in if others share tags. Provides quick reaction buttons and fades out automatically.
- **FollowedSpotsView**: Lists the spots the user has followed for quick access.
- **SearchBar** and **SpotAnnotationView**: Small reusable components for the UI.

These components demonstrate how the prototype currently works and show where new features could be added.
