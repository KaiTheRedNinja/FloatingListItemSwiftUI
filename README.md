# FloatingListItemSwiftUI

FloatingListItemSwiftUI is a SwiftUI framework that allows list items to hover at the top or bottom of the screen
when they are out of view.


https://user-images.githubusercontent.com/88234730/200122776-4c3fa330-5bc8-4f70-a49c-e3d147aaa912.mov

If you find this project interesting or useful, please give me a ⭐ star :D

## Features
- [x] Top and/or bottom pinning
- [x] Device support (tested on the following:)
  - [x] iPhone 14 Pro Max (large pill phone)
  - [x] iPhone SE 3rd Generation (small, chonky phone)
  - [x] iPhone 12 Mini (small notch phone)
- [x] Different sized `View`s (including ones that resize)
- [x] Multiple floating items per list (NOTE: works best with no more than 2 pinned to any side)
- [x] Simple view modifier
- [x] Dark Mode support

## Requirements:
- iOS 16 and above (certain SwiftUI functions are used that are only available on higher versions)
- XCode 14 and above (required to run iOS 16)

## Usage
```swift
import FloatingListItemSwiftUI

struct ExampleListView: View {
    var body: some View {
        List {
            Section {
                ZStack(alignment: .center) {
                    Text("This is a demo of FloatingListItemSwiftUI")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .floatingListItem(floaterID: "info") // <--
                .frame(height: 40)
            }

            Section {
                ForEach(0..<20, id: \.self) { number in
                    Text("Dummy Data \(number)")
                }
            }
        }
        .floatingList(floaterID: "info", pinLocations: .top) // <--
    }
}
```

## Customising Pinning Location

In the `.floatingList` view modifier, the user has the option to set a pinLocation.
- `.bottom` to pin to the bottom (default)
- `.top` to pin to the top
- `all` to pin to both top and bottom
- `none` to pin to neither top nor bottom

## Adding additional floating items

Simply add more `.floatingList` view modifiers to the List and more `.floatingListItem`s. 
Note that the order they are applied **does matter**. For the best looking behaviour, 
it is best to apply at most one on the top and one at the bottom.

```swift
List {
    // ...
}
.floatingList(floaterID: "topPinned", pinLocations: .top)
.floatingList(floaterID: "bottomPinned", pinLocations: .bottom)
```

## How it is implemented

### Calculation

Both the `List` and the `View` share some data via a `FloatingListItemManager` instance ("item manager"). Every time the 
list is scrolled, the `View` gets an update via a `GeometryReader`. The item manager calculates if the
view should be "pinned" to the top/bottom, and also how harsh the shadow should be.

### UI

When `.floatingListItem` is used, the `View` is saved into the item manager. In the List, the `.floatingList` applies an overlay
which applies that view on the top/bottom, hiding/showing it and giving it shadows as needed.

## Implementation Oddities

- Due to the use of GeometryReader and how List works, the user needs to set the `frame` of the view
before and after using `.floatingListItem`.
- `.frame(maxWidth: .infinity)` is required to make the view fill the space while it hovers

## Installation
### Swift Package Manager

The Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate FloatingListItemSwiftUI into your Xcode project using Xcode 11+, specify it in File > Swift Packages > Add:

```
https://github.com/KaiTheRedNinja/FloatingListItemSwiftUI.git
```

## Author
Kai Tay, [KaiTheRedNinja](https://github.com/KaiTheRedNinja/)

## Contributing
Feel free to make a fork and submit a pull request!

## Feedback/bugs
Please file an issue

## License
FloatingListItemSwiftUI is available under the MIT License
