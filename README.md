# PlentiFood Frontend

- [Backend repo](https://github.com/trimakichan/plentifood-api) 
- [Backend hosted](https://plentifood-api.onrender.com/)

### Development environment

- Swift Verstion: Swift 6.2.3 
- Xcode version: Version 26.2 (17C52)
- iOS Deployment target:　18.6　（downgraded to run SE 2nd gen device)
- Mac version used: macOS Squoia (ver 15.6.1)

### Tech Stack
- Swift 5
- SwiftUI
- MapKit


## Features

*   Feature 1: A brief explanation of the feature.
*   Feature 2: Another great feature.
*   Feature 3: And so on.

## Requirements

List the necessary build and runtime requirements.

*   Xcode `[version]` or later
*   iOS `[deployment target]` or later
*   Swift `[version]` or later

## Instructions for setting up the app

Detail how a user can get the project running locally. This often involves dependency management steps.

### [CocoaPods](https://cocoapods.org)

1.  Add the following to your `Podfile`:
    ```ruby
    pod 'DependencyName', '~> 1.0.0'
    ```
2.  Run `pod install` in your terminal.
3.  Open the generated `.xcworkspace` file in Xcode.

### [Swift Package Manager (SPM)](https://swift.org)

1.  In Xcode, select **File** > **Add Packages**.
2.  Enter the repository URL for the dependency.

*(Modify the above sections to match your project's specific dependency manager, such as [Carthage](https://github.com) or manual setup).*

## Configuration

If the project requires specific configuration, such as API keys or entitlements (e.g., iCloud capabilities, push notifications), explain those steps here.

*   **API Keys**: In `ApplicationConstants.swift`, replace `ENTER_CLIENT_ID` with your actual client ID:
    ```swift
    static let clientId = "YOUR_CLIENT_ID"
    ```

## Usage

Provide code snippets or step-by-step instructions on how to use your project or integrate it into another application.

```swift
import ProjectName

// Example of how to use a primary class or function
let exampleManager = ExampleManager()
exampleManager.start()
