# PlentiFood Frontend

- [Backend repo](https://github.com/trimakichan/plentifood-api) 
- [Backend hosted](https://plentifood-api.onrender.com/)

## Features

*   Feature 1: A user can find site location using Map/List toggle.
*   Feature 2: A user can filter sites based on days, organization type, service type, and radius miles. 
*   Feature 3: A user can seach based on a location name.
*   Feature 4: Admin user can view their organization and sites details.
*   Feature 5: Admin user can create organization and sites under a organization. 
*   Feature 6: Admin user can delete their sites.

## Instructions for setting up the app

1. Clone this repository.
2. Open the project PlentiFood.xcodeproj.
3. If neede, update API base URL:
   - Navigate to PlentiFood/API/PlentiFoodAPI.swift.
   - Ensure baseURL matches your backend deployment.
     
4. Select a simulator and press ⌘R to run.

## Development environment

- Swift Verstion: Swift 6.2.3 
- Xcode version: Version 26.2 (17C52)
- iOS Deployment target:　18.6　（downgraded to run SE 2nd gen device)
- Mac version used: macOS Squoia (ver 15.6.1)

## Tech Stack
- Swift 5
- SwiftUI
- MapKit
  

## Requirements

List the necessary build and runtime requirements.

*   Xcode `16.0` or later
*   iOS `18.6` or later
*   Swift `5` or later

## Configuration

I used iOS Deployment target:　18.6 to meet SE 2nd gen. You can still run the latest iphone 17. 

## Testing

Files located at:
- PentifoodTests
- PlentifoodUITests
Press ⌘U to run

I used `App/Dependencies.swift` to create protocol for test setup.



