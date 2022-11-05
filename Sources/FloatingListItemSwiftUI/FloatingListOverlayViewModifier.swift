//
//  FloatingListOverlayViewModifier.swift
//  
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

struct FloatingListOverlayViewModifier<Body: View>: ViewModifier {

    @ObservedObject var itemManager: FloatingListItemManager

    @ViewBuilder
    var hoverContent: () -> Body

    @State var pinLocations: PinLocations

    init(floaterID: String, pinLocations: PinLocations = .bottom, @ViewBuilder content: @escaping () -> Body) {
        self.itemManager = .manager(string: floaterID)
        self.hoverContent = content
        self._pinLocations = State(initialValue: pinLocations)
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay {
                    GeometryReader { geometry in
                        VStack {
                            Spacer().frame(height: 20)
                            if pinLocations == .top || pinLocations == .all {
                                hoverContent()
                                    .onChange(of: geometry.frame(in: .global)) { newValue in
                                        itemManager.pos = newValue
                                    }
                                    .onAppear {
                                        itemManager.pos = geometry.frame(in: .local)
                                    }
                                    .background(tableColor)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .shadow(color: Color.gray, radius: itemManager.topShadow * 10)
                                    .opacity(itemManager.floatingTop ? 1 : 0)
                            }

                            Spacer()

                            if pinLocations == .bottom || pinLocations == .all {
                                hoverContent()
                                    .background(tableColor)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .shadow(color: Color.gray, radius: itemManager.bottomShadow * 10)
                                    .opacity(itemManager.floatingBottom ? 1 : 0)
                            }
                            Spacer().frame(height: 20)
                        }
                    }
                }
        }
    }

    @Environment(\.colorScheme) private var colorScheme
    var tableColor: Color {
        colorScheme == .light ? Color.white : Color(uiColor: UIColor.systemGray6)
    }
}

public enum PinLocations {
    case top
    case bottom
    case all
    case none
}

public extension List {
    func floatingList(floaterID: String,
                      pinLocations: PinLocations = .bottom,
                      @ViewBuilder body: @escaping () -> some View) -> some View {
        self.modifier(FloatingListOverlayViewModifier(floaterID: floaterID, pinLocations: pinLocations, content: body))
    }
}
