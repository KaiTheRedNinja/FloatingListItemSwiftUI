import XCTest
@testable import FloatingListItemSwiftUI

final class FloatingListItemSwiftUITests: XCTestCase {

    func testForYLevel(manager: FloatingListItemManager,
                       yLevel: CGFloat,
                       testTop: Bool) -> Bool {
        manager.scroll = CGRect(x: 40.0, y: yLevel, width: 350.0, height: 40.0)
        return testTop ? manager.floatingTop : manager.floatingBottom
    }

    func testiPhone14() throws {
        let manager = FloatingListItemManager()
        manager.safeAreaTopOverride = 59.0
        manager.safeAreaBottomOverride = 34.0
        manager.pinLocations = .top
        manager.pos = CGRect(x: 0.0, y: 0.0, width: 430.0, height: 839.0)

        // test top floating when actual item is above the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 60, testTop: true), true)

        // test top floating when overlapping EXACTLY    (< 88.3)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 88, testTop: true), true)

        // test top floating when actual item is below the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 105, testTop: true), false)

        manager.pinLocations = .bottom

        // test bottom floating when actual item is above the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 807, testTop: false), false)

        // test bottom floating when overlapping EXACTLY (> 828.3)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 829, testTop: false), true)

        // test bottom floating when actual item is below the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: 849, testTop: false), true)
    }
}
