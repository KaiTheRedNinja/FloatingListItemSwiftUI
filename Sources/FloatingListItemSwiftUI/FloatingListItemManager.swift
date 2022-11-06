//
//  FloatingListItemManager.swift
//
//
//  Created by TAY KAI QUAN on 5/11/22.
//

import SwiftUI

class FloatingListItemManager: ObservableObject {
    /// The position of the floating item
    @Published var scroll: CGRect = .zero

    /// The position of the `List`
    @Published var pos: CGRect = .zero

    /// Which locations the floating item should pin to: top, bottom, all, or none
    @Published var pinLocations: PinLocations = .none

    @Published var floatingItem: AnyView = AnyView(erasing: EmptyView())

    // MARK: TOP
    /// If the item is floating on the top of the screen
    var floatingTop: Bool {
        (topAdjusted < pos.minY && scroll != .zero) &&
        (pinLocations == .top || pinLocations == .all)
    }

    /// The top floating item's shadow's radius, from 0 (not visible) to 1 (fully visible)
    var topShadow: CGFloat {
        if topAdjusted < pos.minY && scroll != .zero {
            // calculate shadow amount
            let difference = pos.minY - topAdjusted
            return min(1, difference/70)
        } else {
            return 0
        }
    }

    private var safeAreaTop: CGFloat { safeAreaTopOverride ?? UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 }
    private let topMagicNumber: CGFloat = 30
    var topAdjusted: CGFloat { scroll.minY - safeAreaTop - topMagicNumber }

    // MARK: BOTTOM
    /// If the item is floating on the bottom of the screen
    var floatingBottom: Bool {
        (bottomAdjusted > pos.maxY || scroll == .zero) &&
        (pinLocations == .bottom || pinLocations == .all)
    }

    /// The bottom floating item's shadow's radius, from 0 (not visible) to 1 (fully visible)
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

    private var safeAreaBottom: CGFloat { safeAreaBottomOverride ?? UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 }
    private let bottomMagicNumber: CGFloat = -5
    var bottomAdjusted: CGFloat { scroll.maxY - safeAreaBottom - bottomMagicNumber }

    // MARK: For testing purposes
    var safeAreaTopOverride: CGFloat? = nil
    var safeAreaBottomOverride: CGFloat? = nil
}

public enum PinLocations {
    /// If the floating item should be pinned to the top
    case top

    /// If the floating item should be pinned to the bottom
    case bottom

    /// If the floating item should be pinned to both the top and bottom
    case all

    /// The floating item should not pin to any side
    case none
}

// MARK: Static things
extension FloatingListItemManager {
    static private var managers: [String: FloatingListItemManager] = [:]

    /// Gets a `FloatingListItemManager` for a certain `String`, creating one if needed.
    ///
    /// This acts as a form of storage. If one requests for a manager with the same string in different
    /// views, they will recieve the same manager.
    /// - Parameter string: The identifier
    /// - Returns: The `FloatingListItemManager` for the string
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
