// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0

import XCTest
@testable import Client

class ReaderModeStyleTests: XCTestCase {
    var themeManager: ThemeManager!

    override func setUp() {
        super.setUp()

        themeManager = AppContainer.shared.resolve()
    }

    override func tearDown() {
        super.tearDown()

        themeManager = nil
    }

    func test_initWithProperties_succeeds() {
        let readerModeStyle = ReaderModeStyle(theme: .dark,
                                              fontType: .sansSerif,
                                              fontSize: .size1)

        XCTAssertEqual(readerModeStyle.theme, ReaderModeTheme.dark)
        XCTAssertEqual(readerModeStyle.fontType, ReaderModeFontType.sansSerif)
        XCTAssertEqual(readerModeStyle.fontSize, ReaderModeFontSize.size1)
    }

    func test_encodingAsDictionary_succeeds() {
        let readerModeStyle = ReaderModeStyle(theme: .dark,
                                              fontType: .sansSerif,
                                              fontSize: .size1)

        let encodingResult: [String: Any] = readerModeStyle.encodeAsDictionary()
        let themeResult = encodingResult["theme"] as? String
        let fontTypeResult = encodingResult["fontType"] as? String
        let fontSizeResult = encodingResult["fontSize"] as? Int
        XCTAssertEqual(themeResult, ReaderModeTheme.dark.rawValue, "Encoding as dictionary theme result doesn't reflect style")
        XCTAssertEqual(fontTypeResult, ReaderModeFontType.sansSerif.rawValue, "Encoding as dictionary fontType result doesn't reflect style")
        XCTAssertEqual(fontSizeResult, ReaderModeFontSize.size1.rawValue, "Encoding as dictionary fontSize result doesn't reflect style")
    }

    func test_initWithDictionnary_succeeds() {
        let readerModeStyle = ReaderModeStyle(dict: ["theme": ReaderModeTheme.dark.rawValue,
                                                     "fontType": ReaderModeFontType.sansSerif.rawValue,
                                                     "fontSize": ReaderModeFontSize.size1.rawValue])

        XCTAssertEqual(readerModeStyle?.theme, ReaderModeTheme.dark)
        XCTAssertEqual(readerModeStyle?.fontType, ReaderModeFontType.sansSerif)
        XCTAssertEqual(readerModeStyle?.fontSize, ReaderModeFontSize.size1)
    }

    func test_initWithWrongDictionnary_fails() {
        let readerModeStyle = ReaderModeStyle(dict: ["wrong": 1,
                                                     "fontType": ReaderModeFontType.sansSerif,
                                                     "fontSize": ReaderModeFontSize.size1])

        XCTAssertNil(readerModeStyle)
    }

    func test_initWithEmptyDictionnary_fails() {
        let readerModeStyle = ReaderModeStyle(dict: [:])

        XCTAssertNil(readerModeStyle)
    }

    // MARK: - ReaderModeTheme

    func test_defaultReaderModeTheme_returnsLight() {
        themeManager.changeCurrentTheme(.light)
        let defaultTheme = ReaderModeTheme.preferredTheme(for: nil)
        XCTAssertEqual(defaultTheme, .light, "Expected light theme (default) if not theme is selected")
    }

    func test_appWideThemeDark_returnsDark() {
        themeManager.changeCurrentTheme(.dark)
        let theme = ReaderModeTheme.preferredTheme(for: ReaderModeTheme.light)

        XCTAssertEqual(theme, .dark, "Expected dark theme because of the app theme")
    }

    func test_readerThemeSepia_returnsSepia() {
        themeManager.changeCurrentTheme(.light)
        let theme = ReaderModeTheme.preferredTheme(for: ReaderModeTheme.sepia)
        XCTAssertEqual(theme, .sepia, "Expected sepia theme if App theme is not dark")
    }

    func test_readerThemeSepiaWithAppDark_returnsSepia() {
        themeManager.changeCurrentTheme(.dark)
        let theme = ReaderModeTheme.preferredTheme(for: ReaderModeTheme.sepia)
        XCTAssertEqual(theme, .dark, "Expected dark theme if App theme is dark")
    }

    func test_preferredColorTheme_changesFromLightToDark() {
        themeManager.changeCurrentTheme(.dark)
        var readerModeStyle = ReaderModeStyle(theme: .light,
                                              fontType: .sansSerif,
                                              fontSize: .size1)
        XCTAssertEqual(readerModeStyle.theme, .light)
        readerModeStyle.ensurePreferredColorThemeIfNeeded()
        XCTAssertEqual(readerModeStyle.theme, .dark)
    }
}
