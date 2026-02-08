//
//  NearbySitesViewModelTests.swift
//  PlentifoodTests
//
//  Created by Mami on 2/7/26.
//

import Foundation

import XCTest
@testable import Plentifood
import CoreLocation



@MainActor
final class NearbySitesViewModelTests: XCTestCase {

    func testLoadSuccess_setsSitesAndTotalResults_andClearsError() async {
      let api = MockPlentiFoodAPI()
       api.nextResponse = .fixture(
            total: 2,
            results: [
               .fixture(id: 1, name: "A"),
               .fixture(id: 2, name: "B")
            ]
        )

      let vm = NearbySitesViewModel(api: api, geocoder: MockGeocoder())

       await vm.load(lat: 47.0, lon: -122.0, radiusMiles: 10)

        XCTAssertEqual(vm.totalResults, 2)
        XCTAssertEqual(vm.sites.map(\.name), ["A", "B"])
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
   }
    
    
    func testLoadFailure_setsErrorMessage_clearsSites_stopsLoading() async {
        let api = MockPlentiFoodAPI()
        api.nextError = TestError.boom

        let vm = NearbySitesViewModel(api: api, geocoder: MockGeocoder())
        
        // Preload data to prove it gets cleared
        vm.sites = [
            .fixture(id: 1, name: "Old Site")
        ]
        vm.totalResults = 1

        await vm.load(lat: 47.0, lon: -122.0, radiusMiles: 10)

        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(vm.sites.isEmpty)
        XCTAssertEqual(vm.totalResults, 0)
        XCTAssertFalse(vm.isLoading)
    }
    
    func testLoad_passesFiltersToAPI() async {
          let api = MockPlentiFoodAPI()
          api.nextResponse = .fixture(total: 0, results: [])

          let vm = NearbySitesViewModel(api: api, geocoder: MockGeocoder())
          vm.filters = .default  // or set a non-default if you have one

          await vm.load(lat: 1, lon: 2, radiusMiles: 3)

          XCTAssertEqual(api.lastLat, 1)
          XCTAssertEqual(api.lastLon, 2)
          XCTAssertEqual(api.lastRadius, 3)
          XCTAssertNotNil(api.lastFilters)
       }
    
    @MainActor
    func testLoad_passesCurrentFiltersToAPI() async {
       let api = MockPlentiFoodAPI()
       api.nextResponse = .fixture(total: 0, results: [])

       let vm = NearbySitesViewModel(api: api, geocoder: MockGeocoder())

       // Arrange: set filters to something you can recognize
       vm.filters = .default  // Replace with a non-default if you have one, e.g. .init(...)

       // Act
       await vm.load(lat: 1, lon: 2, radiusMiles: 3)

       // Assert
       XCTAssertNotNil(api.lastFilters)
       XCTAssertEqual(api.lastFilters, vm.filters)
    }

    
}

