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
    func testAEArticleConverterParagraphNode() {
        let content = "<p>こんにちは</p>"
        
        let nodes = AEArticleConverter.default.purse(content)
        XCTAssertNotNil(nodes[0] as? AEParagraphArticleNode)
        
        let pnode = nodes[0] as! AEParagraphArticleNode
        XCTAssertEqual(pnode.text, "こんにちは")
    }
    
    func testAEArticleConverterImageNode(){
        let imageAddress = "https://i.gzn.jp/img/2019/03/15/iphone-saves-owner-arrow-attack/00_m.jpg"
        let content = "<img src=\"\(imageAddress)\">"
        
        let nodes = AEArticleConverter.default.purse(content)
        XCTAssertNotNil(nodes[0] as? AEImageArticleNode)
        
        let pnode = nodes[0] as! AEImageArticleNode
        XCTAssertEqual(pnode.src, imageAddress)
    }
    
    func testAEArticleConverterNameNode() {
        let content = "<em>大渕雄生</em>"
        
        let nodes = AEArticleConverter.default.purse(content)
        XCTAssertNotNil(nodes[0] as? AENameArticleNode)
        
        let pnode = nodes[0] as! AENameArticleNode
        XCTAssertEqual(pnode.text, "大渕雄生")
    }
    
    func testAEArticleConverterHeadLineNode() {
        let content = "<h1>タイトル</h1>"
        
        let nodes = AEArticleConverter.default.purse(content)
        XCTAssertNotNil(nodes[0] as? AEHeadlineArticleNode)
        
        let pnode = nodes[0] as! AEHeadlineArticleNode
        XCTAssertEqual(pnode.text, "タイトル")
        XCTAssertEqual(pnode.level, .h1)
    }
    
    func testAEArticleConverterMultipulNodes() {
        let content = """
<h1>タイトル</h1>
<p>こんにちは</p>
<img src="https://mx-sh.net/images/logo1_1x.png">
<em>大渕雄生</em>
"""
        
        let nodes = AEArticleConverter.default.purse(content)
        
        XCTAssertEqual(nodes.count, 4)
        
        XCTAssertNotNil(nodes[0] as? AEHeadlineArticleNode)
        XCTAssertNotNil(nodes[1] as? AEParagraphArticleNode)
        XCTAssertNotNil(nodes[2] as? AEImageArticleNode)
        XCTAssertNotNil(nodes[3] as? AENameArticleNode)
        
        let pnode1 = nodes[0] as! AEHeadlineArticleNode
        let pnode2 = nodes[1] as! AEParagraphArticleNode
        let pnode3 = nodes[2] as! AEImageArticleNode
        let pnode4 = nodes[3] as! AENameArticleNode
        
        XCTAssertEqual(pnode1.text, "タイトル")
        XCTAssertEqual(pnode1.level, .h1)
        
        XCTAssertEqual(pnode2.text, "こんにちは")
        
        XCTAssertEqual(pnode3.src, "https://mx-sh.net/images/logo1_1x.png")
        
        XCTAssertEqual(pnode4.text, "大渕雄生")
    }
}
