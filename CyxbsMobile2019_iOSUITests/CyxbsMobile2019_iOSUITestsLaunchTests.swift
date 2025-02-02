//
//  CyxbsMobile2019_iOSUITestsLaunchTests.swift
//  CyxbsMobile2019_iOSUITests
//
//  Created by SSR on 2023/9/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

import XCTest

class CyxbsMobile2019_iOSUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
