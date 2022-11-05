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

    init(floaterID: String, @ViewBuilder content: @escaping () -> Body) {
        self.itemManager = .manager(string: floaterID)
        self.hoverContent = content
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            hoverContent()
                            .onChange(of: geometry.frame(in: .local)) { newValue in
                                print("Exit pos: \(newValue)")
                                itemManager.exitPos = newValue
                            }
                            .onAppear {
                                itemManager.exitPos = geometry.frame(in: .local)
                            }
                            .background(tableColor)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .shadow(color: Color.gray, radius: itemManager.exitShadow * 10)
                            .opacity(itemManager.floatingExit ? 1 : 0)
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

public extension List {
    func floatingList(floaterID: String, @ViewBuilder body: @escaping () -> some View) -> some View {
        self.modifier(FloatingListOverlayViewModifier(floaterID: floaterID, content: body))
    }
}
