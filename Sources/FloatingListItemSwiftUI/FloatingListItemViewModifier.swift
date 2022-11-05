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
                    print("Scrol pos: \(newValue)")
                    itemManager.scroll = newValue
                }
                .onAppear {
                    itemManager.scroll = geometry.frame(in: .global)
                }
                .opacity(itemManager.floatingExit ? 0.001 : 1)
        }
    }
}

public extension View {
    func floatingListItem(floaterID: String) -> some View {
        self.modifier(FloatingListItemViewModifier(floaterID: floaterID))
    }
}
