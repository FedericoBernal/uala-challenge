# Uala Cities Challenge - iOS App

## Project Overview
This iOS application is designed to display and search through a list of approximately 200,000 cities. The app provides efficient search functionality, city information display, and map integration.

## Technical Approach

### Search Algorithm
The search implementation uses a **prefix-based search algorithm** optimized for performance:

1. **Data Structure**: Cities are preprocessed into a sorted array by city name, then country code
2. **Search Strategy**: Binary search with prefix matching for O(log n) average case performance
3. **Case Insensitive**: All searches are performed case-insensitive for better user experience
4. **Real-time Updates**: Search results update with every keystroke for responsive UI

### Key Design Decisions

#### Architecture
- **SwiftUI**: Modern declarative UI framework for responsive and maintainable code
- **MVVM Pattern**: Separation of concerns with clear data flow
- **Protocol-Oriented Design**: Flexible and testable architecture

#### Data Management
- **Local Storage**: Core Data for persistent favorites storage
- **Memory Optimization**: Efficient data structures to handle large datasets
- **Lazy Loading**: Cities loaded on-demand to maintain app performance

#### UI/UX Considerations
- **Responsive Design**: Adaptive layouts for portrait/landscape orientations
- **Accessibility**: VoiceOver support and semantic markup
- **Performance**: Smooth scrolling and real-time search updates

### Assumptions Made
1. Cities data is relatively static and can be downloaded once per app session
2. Search performance is prioritized over initial load time
3. Favorites are stored locally and persist between app launches
4. Map integration uses Apple Maps for native iOS experience