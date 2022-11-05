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
    @Published var pinLocations: PinLocations = .none

    // MARK: TOP
    var floatingTop: Bool {
        (topAdjusted < pos.minY && scroll != .zero) &&
        (pinLocations == .top || pinLocations == .all)
    }

    var topShadow: CGFloat {
        if topAdjusted < pos.minY && scroll != .zero {
            // calculate shadow amount
            let difference = pos.minY - topAdjusted
            return min(1, difference/70)
        } else {
            return 0
        }
    }

    var safeAreaTop: CGFloat { UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 }
    let topMagicNumber: CGFloat = 25
    var topAdjusted: CGFloat { scroll.minY - safeAreaTop - topMagicNumber }

    // MARK: BOTTOM
    var floatingBottom: Bool {
        (bottomAdjusted > pos.maxY || scroll == .zero) &&
        (pinLocations == .bottom || pinLocations == .all)
    }

    var bottomShadow: CGFloat {
        if bottomAdjusted > pos.maxY || scroll == .zero {
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

public enum PinLocations {
    case top
    case bottom
    case all
    case none
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
