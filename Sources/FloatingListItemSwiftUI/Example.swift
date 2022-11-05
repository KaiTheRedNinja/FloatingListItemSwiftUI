//
//  Example.swift
//  
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

struct ResultsView: View {

    var words: [String]

    @State var scroll: CGRect = .zero
    @State var exitPos: CGRect = .zero
    @State var difference: CGFloat = 0

    var body: some View {
        List {
            Section {
                ForEach(words, id: \.self) { word in
                    HStack {
                        Text(word)
                            .frame(height: 100)
                    }
                }
            }

            Section {
                GeometryReader { geometry in
                    Button("Exit") {
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: geometry.frame(in: .global)) { newValue in
                        print("Scrol pos: \(newValue)")
                        scroll = newValue
                    }
                    .onAppear {
                        scroll = geometry.frame(in: .global)
                    }
                    .opacity(floatingExit ? 0.001 : 1)
                }
                .listRowBackground(floatingExit ? Color.clear : tableColor)
            }
        }
        .overlay {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Button("Exit") {

                    }
                    .onChange(of: geometry.frame(in: .local)) { newValue in
                        print("Exit pos: \(newValue)")
                        exitPos = newValue
                    }
                    .onAppear {
                        exitPos = geometry.frame(in: .local)
                    }
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background(tableColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.gray, radius: exitShadow * 10)
                    .opacity(floatingExit ? 1 : 0)
                    Spacer().frame(height: 20)
                }
            }
        }
        .navigationTitle("Results")
    }

    @Environment(\.colorScheme) var colorScheme
    var tableColor: Color {
        colorScheme == .light ? Color.white : Color(uiColor: UIColor.systemGray6)
    }

    var floatingExit: Bool {
        scroll.minY-scroll.height > exitPos.height || scroll == .zero
    }

    var exitShadow: CGFloat {
        if scroll.minY-scroll.height > exitPos.height ||
            scroll == .zero {
            guard scroll != .zero else { return 1 }
            // calculate shadow amount
            difference = (scroll.minY-scroll.height) - exitPos.height
            return min(1, difference/70)
        } else {
            return 0
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultsView(words: [
                "hi",
                "hi2",
                "hi3",
                "hi4",
                "hi5",
                "hi6",
                "hi7",
                "hi8",
                "hi9"
            ])
        }
    }
}

