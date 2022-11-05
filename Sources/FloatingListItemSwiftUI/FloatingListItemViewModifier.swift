//
//  FloatingListItemViewModifier.swift
//  
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

struct FloatingListItemViewModifier: ViewModifier {
    @ObservedObject var itemManager: FloatingListItemManager

    init(floaterID: String) {
        itemManager = .manager(string: floaterID)
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onChange(of: geometry.frame(in: .global)) { newValue in
                    itemManager.scroll = newValue
                }
                .onAppear {
                    itemManager.scroll = geometry.frame(in: .global)
                }
                .opacity(itemManager.floatingBottom ? 0.001 : 1)
        }
        .listRowBackground(itemManager.floatingBottom ? Color.clear : tableColor)
    }

    @Environment(\.colorScheme) private var colorScheme
    var tableColor: Color {
        colorScheme == .light ? Color.white : Color(uiColor: UIColor.systemGray6)
    }
}

public extension View {
    func floatingListItem(floaterID: String) -> some View {
        self.modifier(FloatingListItemViewModifier(floaterID: floaterID))
    }
}
