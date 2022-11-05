//
//  FloatingListOverlayViewModifier.swift
//  
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

struct FloatingListOverlayViewModifier: ViewModifier {

    @ObservedObject var itemManager: FloatingListItemManager

    init(floaterID: String, pinLocations: PinLocations = .bottom) {
        self.itemManager = .manager(string: floaterID)
        self.itemManager.pinLocations = pinLocations
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay {
                    GeometryReader { geometry in
                        VStack {
                            Spacer().frame(height: 20)
                            if itemManager.pinLocations == .top || itemManager.pinLocations == .all {
                                formattedContent(shadowSize: itemManager.topShadow, floating: itemManager.floatingTop)
                            }

                            Spacer()

                            if itemManager.pinLocations == .bottom || itemManager.pinLocations == .all {
                                formattedContent(shadowSize: itemManager.bottomShadow, floating: itemManager.floatingBottom)
                            }
                            Spacer().frame(height: 20)
                        }
                        .onChange(of: geometry.frame(in: .global)) { newValue in
                            // detect if the position of the List has changed
                            // update pos accordingly
                            itemManager.pos = newValue
                        }
                        .onAppear {
                            itemManager.pos = geometry.frame(in: .local)
                            // update pos when content appears for the first time,
                            // as the item's scroll position may not have nescessarily changed
                        }
                    }
                }
        }
    }

    @ViewBuilder
    func formattedContent(shadowSize: CGFloat, floating: Bool) -> some View {
        itemManager.floatingItem
            .padding(.horizontal, 20)   // to mimick the internal spacing of a List
            .background(tableColor)     // to mimick the background of a List
            .cornerRadius(10)           // to mimick the corner radius of a List
            .shadow(color: Color.gray, radius: shadowSize * 10) // to distinguish the floating item from the other List items
            .padding(.horizontal, 20)   // to mimick the external spacing of a list
            .opacity(floating ? 1 : 0) // hidden when not needed
    }

    @Environment(\.colorScheme) private var colorScheme
    var tableColor: Color {
        colorScheme == .light ? Color.white : Color(uiColor: UIColor.systemGray6)
    }
}

public extension List {
    /// Marks a `List` as containing a floating list item
    ///
    /// The `floaterID` must be the SAME between the `List` and the `View` that the developer wants to float
    ///
    /// - Parameter floaterID: The ID of the View
    /// - Parameter pinLocations: The locations where the floating list item should pin
    /// - Parameter body: The floating `View`
    func floatingList(floaterID: String,
                      pinLocations: PinLocations = .bottom) -> some View {
        self.modifier(FloatingListOverlayViewModifier(floaterID: floaterID, pinLocations: pinLocations))
    }
}
