//
//  PageEditorTests.swift
//  PageEditorTests
//
//  Created by yuki on 2019/03/15.
//  Copyright © 2019 yuki. All rights reserved.
//

import XCTest
@testable import PageEditor

class PageEditorTests: XCTestCase {
    let _articles = [2, 12, 34, 65]
    
    private func _reverceIndex(from index:Int) -> Int{
        return _articles.count - index + 1
    }
    func testReverce(){
        let rA = Array(_articles.reversed())
        let index = 2
        let rindex = _reverceIndex(from: 2)
        
        XCTAssertEqual(rindex, 3)
    }
}
