import Foundation
import Quick
import Nimble
@testable import HomeTime

class TramServiceTest: QuickSpec {
    override func spec() {
        describe("TramService") {
            
            var tramService: TramServiceType!
            var tokenService: TramServiceType!
            
            beforeEach {
                let mockTokenSession = MockTokenSession()
                tokenService = TramService(session: mockTokenSession)
                
                let mockTramSession = MockTramSession()
                tramService = TramService(session: mockTramSession, token: "dev")
            
            }
            
            it("should get the token") {
                tokenService.fetchApiToken { (result) in
                    switch result {
                    case .success(let token):
                        expect(token) == "some-valid-device-token"
                        break
                    case .failure:
                        fail("Expecting to get token")
                        break
                    }
                }
            }
            
            it("should get the tram service") {
                tramService.loadTramDataUsing(stopId: "4055") { (result) in
                    switch result {
                    case .success(let tramList):
                        guard let trams = tramList else {
                            fail("Expecting to get tram data")
                            return
                        }
                        expect(trams.count) == 1
                        expect(trams[0].routeNo) == "78"
                        expect(trams[0].destination) == "North Richmond"
                        expect(trams[0].predictedArrivalDateTime) == "/Date(1426821588000+1100)/"
                        break
                    case .failure:
                        fail("Expecting to get tram data")
                        break
                    }
                }
            }
            
            it ("should get the correct error message") {
                let mockFailSession = MockFailSession()
                let tramFailService = TramService(session: mockFailSession)
                
                tramFailService.fetchApiToken { (result) in
                    switch result {
                    case .success:
                        fail("Expecting to get error message")
                        break
                    case .failure(let error):
                        expect(error?.localizedDescription.hasPrefix("Something went wrong")) == true
                        break
                    }
                }
            }
        }
    }
}
