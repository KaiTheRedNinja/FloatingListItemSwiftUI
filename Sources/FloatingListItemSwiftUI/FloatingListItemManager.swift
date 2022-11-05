//
//  FloatingListItemManager.swift
//
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

class FloatingListItemManager: ObservableObject {
    @Published var scroll: CGRect = .zero
    @Published var exitPos: CGRect = .zero

    var floatingExit: Bool {
        scroll.maxY-scroll.height > exitPos.height || scroll == .zero
    }

    var exitShadow: CGFloat {
        if scroll.maxY-scroll.height > exitPos.height ||
            scroll == .zero {
            guard scroll != .zero else { return 1 }
            // calculate shadow amount
            let difference = (scroll.maxY-scroll.height) - exitPos.height
            return min(1, difference/70)
        } else {
            return 0
        }
    }
}

// MARK: Static things
extension FloatingListItemManager {
    static private var managers: [String: FloatingListItemManager] = [:]

    static func manager(string: String) -> FloatingListItemManager {
        if let manager = managers[string] {
            return manager
        } else {
            let newManager = FloatingListItemManager()
            managers[string] = newManager
            return newManager
        }
    }
}
