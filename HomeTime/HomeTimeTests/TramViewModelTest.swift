//
//  TramViewModelTest.swift
//  HomeTimeTests
//
//  Created by iOS Developer on 12/5/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import HomeTime

class TramViewModelTest: QuickSpec {
    override func spec() {
        describe("TramViewModel") {
            var viewModel: TramViewModelType!
            beforeEach {
                let mockTramSession = MockTramSession()
                let tramService = TramService(session: mockTramSession, token: "dev")
                viewModel = TramViewModel(service: tramService)
                viewModel.loadTramData()
            }
        
            it ("should get correct north tram number") {
                expect(viewModel.getNorthTramsCount()) == 1
            }
            
            it ("should get south tram number") {
                expect(viewModel.getSouthTramsCount()) == 1
            }
            
            it("should get route number") {
                let routeNo = viewModel.getTramNumber(at: IndexPath(row: 0, section: 0))
                expect(routeNo) == "Route: 78"
            }
            
//            it ("should get tram arrival time") {
//                let arrivalTime = viewModel.getTramArrivalTime(at: IndexPath(row: 0, section: 0))
//                expect(arrivalTime) == "02:19 PM"
//            }
//            
//            it ("should get time interval") {
//                let mockedDate =  DotNetDateConverter().dateFromDotNetFormattedDateString("/Date(1426821588000+1100)/")!
//                let timeInteval = viewModel.getTimeInterval(at: IndexPath(row: 0, section: 0), sinceTime: mockedDate)
//                
//                expect(timeInteval) == " (now)"
//            }
            
            it ("should get destination") {
                let dest = viewModel.getDestination(at: IndexPath(row: 0, section: 0))
                expect(dest) == "North Richmond"
            }
            
            
            it ("should display error message") {
                let mock = MockFailSession()
                let tramService = TramService(session: mock, token: "dev")
                let failViewModel = TramViewModel(service: tramService)
                failViewModel.showAlertClosure = {  (message) in
                    expect(message.hasPrefix("Something went wrong")) == true
                }
                failViewModel.loadTramData()
                
            }
            
            it ("should reload table after loading api") {
                viewModel.reloadTable = {
                    expect(true) == true
                }
                viewModel.loadTramData()
            }
            
            it ("should reload table after clear data") {
                viewModel.reloadTable = {
                    expect(true) == true
                }
                viewModel.clearTramData()
            }
        }
    }
}
