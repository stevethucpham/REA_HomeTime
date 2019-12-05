//
//  Copyright © 2017 REA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import HomeTime

// MARK: -

class TramViewControllerSpec: QuickSpec {
  
  override func spec() {
    describe("TramViewController") {
      var viewController: TramViewController?

      beforeEach {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "TramViewController") as? TramViewController
        viewController?.loadViewIfNeeded()
      }

      it("should have sections for north and south") {
        let sections = viewController?.tramTimesTable.numberOfSections

        expect(sections) == 2
      }

      it("should initialize no tram data") {
        let tramsTable = viewController?.tramTimesTable
        let north = tramsTable?.numberOfRows(inSection: 0)
        expect(north) == 1

        let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as? TramTableCell
        let placeholder = placeholderCell?.arrivalTimeLabel.text
        expect(placeholder?.hasPrefix("No upcoming trams")) == true

        let south = tramsTable?.numberOfRows(inSection: 1)
        expect(south) == 1
      }

      it("should display data on table cell after load api response") {
        let mockSession = MockTramSession()
        let tramService = TramService(session: mockSession, token: "dev")
        
        let viewModel = TramViewModel(service: tramService)

        viewModel.loadTramData()
        
        viewController?.viewModel = viewModel
        
        let tramsTable = viewController?.tramTimesTable
        let northTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramTableCell
        expect(northTramCell.routeNumberLabel?.text) == "Route: 78"
        expect(northTramCell.arrivalTimeLabel?.text) == "02:19 PM"
        expect(northTramCell.destinationLabel?.text) == "North Richmond"
        
        let southTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 1)) as! TramTableCell
        expect(southTramCell.routeNumberLabel?.text) == "Route: 78"
        expect(southTramCell.arrivalTimeLabel?.text) == "02:19 PM"
        expect(southTramCell.destinationLabel?.text) == "North Richmond"
      }
        
        it ("should clear data on table cell after clicking clear button") {
            let viewModel = TramViewModel()
            viewModel.clearTramData()
            viewController?.viewModel = viewModel
            let tramsTable = viewController?.tramTimesTable
            
            let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as? TramTableCell
            let placeholder = placeholderCell?.arrivalTimeLabel.text
            expect(placeholder?.hasPrefix("No upcoming trams")) == true

            let south = tramsTable?.numberOfRows(inSection: 1)
            expect(south) == 1
        }
        
        it ("should display alert when loading API failure") {
            
            let mock = MockFailSession()
            let tramService = TramService(session: mock, token: "dev")
            
            let viewModel = TramViewModel(service: tramService)
            viewModel.showAlertClosure = {  (message) in
                expect(message.hasPrefix("Something went wrong")) == true
            }
                
            viewController?.viewModel = viewModel
            viewModel.loadTramData()

        }
    }
    

  }
}
