//
//  FloatingListItemManager.swift
//
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

class FloatingListItemManager: ObservableObject {
    @Published var scroll: CGRect = .zero
    @Published var pos: CGRect = .zero

    var floatingBottom: Bool {
        scroll.maxY-scroll.height > pos.height || scroll == .zero
    }

    var bottomShadow: CGFloat {
        if scroll.maxY-scroll.height > pos.height ||
            scroll == .zero {
            guard scroll != .zero else { return 1 }
            // calculate shadow amount
            let difference = (scroll.maxY-scroll.height) - pos.height
            return min(1, difference/70)
        } else {
            return 0
        }
    }

    var floatingTop: Bool {
        scroll.maxY-scroll.height - 85 < pos.minX && scroll != .zero
    }

    var topShadow: CGFloat {
        if scroll.maxY-scroll.height - 85 < pos.minX &&
            scroll != .zero {
            // calculate shadow amount
            let difference = pos.minX - (scroll.maxY-scroll.height - 85)
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
