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

    // MARK: TOP
    var floatingTop: Bool {
        topAdjusted < pos.minY && scroll != .zero
    }

    var topShadow: CGFloat {
        if topAdjusted < pos.minY &&
            scroll != .zero {
            // calculate shadow amount
            let difference = pos.minY - topAdjusted
            return min(1, difference/70)
        } else {
            return 0
        }
    }

    var safeAreaTop: CGFloat { UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 }
    let topMagicNumber: CGFloat = 20
    var topAdjusted: CGFloat { scroll.minY - safeAreaTop - topMagicNumber }

    // MARK: BOTTOM
    var floatingBottom: Bool {
        bottomAdjusted > pos.maxY || scroll == .zero
    }

    var bottomShadow: CGFloat {
        if bottomAdjusted > pos.maxY ||
            scroll == .zero {
            guard scroll != .zero else { return 1 }
            // calculate shadow amount
            let difference = bottomAdjusted - pos.maxY
            return min(1, difference/70)
        } else {
            return 0
        }
    }

    var safeAreaBottom: CGFloat { UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 }
    let bottomMagicNumber: CGFloat = 0
    var bottomAdjusted: CGFloat { scroll.maxY - safeAreaBottom - bottomMagicNumber }

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
