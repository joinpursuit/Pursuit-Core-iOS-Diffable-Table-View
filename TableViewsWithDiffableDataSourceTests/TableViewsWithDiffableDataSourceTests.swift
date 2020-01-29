//
//  TableViewsWithDiffableDataSourceTests.swift
//  TableViewsWithDiffableDataSourceTests
//
//  Created by Benjamin Stone on 1/29/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import XCTest
@testable import TableViewsWithDiffableDataSource

class TableViewsWithDiffableDataSourceTests: XCTestCase {
    func testExample() {
        let episodesFetchingService = BundleFetchingService<Episode>()
        let episodes = episodesFetchingService.getArray(from: "officeEpisodes", ofType: "json")
        XCTAssertEqual(episodes.count, 201, "Was expecting 201 epiodes, but saw \(episodes.count)")
    }
}
