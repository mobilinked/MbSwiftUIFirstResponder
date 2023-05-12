# SwiftUI First Responder

SwiftUI First Responder is a Swift package that provides easy control over the first responder in iOS prior to 15.0 and macOS prior to 12.0, using SwiftUI style APIs for TextField, SecureField, and TextEditor.

## Key Features

- SwiftUI style APIs for TextField, SecureField, and TextEditor.
- Tap outside to resign the first responder.
- Designed for iOS and macOS apps.

## Usage

```swift
TextField("Name", text: $name)
    .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .all)

TextEditor(text: $notes)
    .firstResponder(id: FirstResponders.notes, firstResponder: $firstResponder, resignableUserOperations: .all)
```

## Goal

Before iOS 15.0 and macOS 12.0, SwiftUI did not offer official support for controlling the first responder of text inputs. When we began enhancing our [QuickPlan](https://quickplan.app) app's user interfaces using SwiftUI, we realized that the first responder control had a significant impact on the user experience.

Our aim was to create a solution with the following principles:

* Continue to use SwiftUI views.
* Use SwiftUI style API calls to control the first responder.
* Add additional controls for events like tapping outside or pressing the escape key.

## Note

- This package provides a temporary solution for controlling the first responder for iOS prior to 15.0 and macOS prior to 12.0. 
- This solution depends on the run-time (UIKit and AppKit) view structure - the code analyzes the run-time views and adds additional controls to the UIKit and AppKit views.
- It may **NOT** work in the future. The method used for this solution may not be possible as the SwiftUI implementation may change.

## Installation

To use SwiftUI First Responder in your project, you'll need:

- Xcode 12 or later
- iOS 14 or later
- macOS 11 or later

To install the package:

1. In Xcode go to `File -> Swift Packages -> Add Package Dependency`
2. Paste in the repo's url: `https://github.com/Mobilinked/MbSwiftUIFirstResponder`

## Demo

To see SwiftUI First Responder in action, please run the demo project within the package.

## Demo Video

Click the image below to play the demo video.

[![First Responder Demo](https://img.youtube.com/vi/zcUd2grpoz4/0.jpg)](https://www.youtube.com/watch?v=zcUd2grpoz4)
