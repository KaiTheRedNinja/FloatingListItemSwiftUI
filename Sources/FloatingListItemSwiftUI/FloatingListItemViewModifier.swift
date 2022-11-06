//
//  FloatingListItemViewModifier.swift
//  
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

struct FloatingListItemViewModifier<Body: View>: ViewModifier {
    @ObservedObject var itemManager: FloatingListItemManager

    @ViewBuilder
    var view: () -> Body

    init(floaterID: String, @ViewBuilder view: @escaping () -> Body) {
        self.itemManager = .manager(string: floaterID)
        self.view = view
        itemManager.floatingItem = AnyView(erasing: view())
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onChange(of: geometry.frame(in: .global)) { newValue in
                    // detect if the position in the List's scroll view has changed
                    // update scroll accordingly
                    itemManager.scroll = newValue
                    debug()
                }
                .onAppear {
                    // update scroll when content appears for the first time,
                    // as the item's scroll position may not have nescessarily changed
                    itemManager.scroll = geometry.frame(in: .global)
                    print("Bezels: \(UIApplication.shared.windows.first?.safeAreaInsets.top) \(UIApplication.shared.windows.first?.safeAreaInsets.bottom)")
                    debug()
                }
                // set to 0.001 opacity if the item is floating. It is not 0 so that the view
                // still takes up space but yet is invisible, at least to human eyes.
                .opacity((itemManager.floatingBottom || itemManager.floatingTop) ? 0.001 : 1)
        }
        // if the item is floating, set the background to transparent
        .listRowBackground((itemManager.floatingBottom || itemManager.floatingTop) ? Color.clear : tableColor)
    }

    @Environment(\.colorScheme) private var colorScheme
    /// The color of the table, following the color scheme
    var tableColor: Color {
        colorScheme == .light ? Color.white : Color(uiColor: UIColor.systemGray6)
    }

    func debug() {
        print("Scroll: \(itemManager.scroll)")
        print("Pos:    \(itemManager.pos)")
        print("FloatB: \(itemManager.floatingBottom)")
    }
}

public extension View {
    /// Marks a `View` as a floating list item
    ///
    /// Does nothing if the `View`'s parent `List` is not marked with `.floatingList(floaterID:)`
    /// The `floaterID` must be the SAME.
    ///
    /// - Parameter floaterID: The ID of the View
    func floatingListItem(floaterID: String) -> some View {
        self.modifier(FloatingListItemViewModifier(floaterID: floaterID, view: { self }))
    }
}
