import XCTest
@testable import FloatingListItemSwiftUI

final class FloatingListItemSwiftUITests: XCTestCase {

    // how far apart the measurements are
    // eg. for 20, it would test exactly the value, value+20, and value-20
    let tightness: CGFloat = 20

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

        let topVal: CGFloat = 88
        let botVal: CGFloat = 829

        // test top floating when actual item is above the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal-tightness, testTop: true), true)

        // test top floating when overlapping EXACTLY    (< 88.3)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal, testTop: true), true)

        // test top floating when actual item is below the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal+tightness, testTop: true), false)

        manager.pinLocations = .bottom

        // test bottom floating when actual item is above the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal-tightness, testTop: false), false)

        // test bottom floating when overlapping EXACTLY (> 828.3)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal, testTop: false), true)

        // test bottom floating when actual item is below the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal+tightness, testTop: false), true)
    }

    func testiPhoneSE() throws {
        let manager = FloatingListItemManager()
        manager.safeAreaTopOverride = 20.0
        manager.safeAreaBottomOverride = 0.0
        manager.pinLocations = .top
        manager.pos = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 647.0)

        let topVal: CGFloat = 49
        let botVal: CGFloat = 602.5

        // test top floating when actual item is above the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal-tightness, testTop: true), true)

        // test top floating when overlapping EXACTLY    (<= 49.0)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal, testTop: true), true)

        // test top floating when actual item is below the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: topVal+tightness, testTop: true), false)

        manager.pinLocations = .bottom

        // test bottom floating when actual item is above the cloned item (hide)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal-tightness, testTop: false), false)

        // test bottom floating when overlapping EXACTLY (>= 602.5)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal, testTop: false), true)

        // test bottom floating when actual item is below the cloned item (show)
        XCTAssertEqual(testForYLevel(manager: manager, yLevel: botVal+tightness, testTop: false), true)
    }
}
