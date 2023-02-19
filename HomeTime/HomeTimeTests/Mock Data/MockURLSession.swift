import Foundation
@testable import HomeTime

class MockURLSessionDataTask: URLSessionDataTask {
  override func resume() {
    print("mock resume")
  }
}
// MARK: MockToken Session
class MockTokenSession: URLSession {
     override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let jsonString =  """
            {
                "responseObject": [
                  {
                    "DeviceToken": "some-valid-device-token"
                  }
                ]
            }
        """
        let data = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: Constants.CellIdentifier.tramCell)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(data, response, nil)
        return MockURLSessionDataTask()
      }
}

// MARK: Mock Tram Service Session
class MockTramSession: URLSession {
  override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

    let jsonString =  """
{
"responseObject" :
  [
    {
    "Destination" : "North Richmond",
    "PredictedArrivalDateTime": "/Date(1426821588000+1100)/",
    "RouteNo" : "78"
    }
  ]
}
"""
    let data = jsonString.data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: Constants.CellIdentifier.tramCell)!, statusCode: 200, httpVersion: nil, headerFields: nil)
    completionHandler(data, response, nil)

    return MockURLSessionDataTask()
  }
}

// MARK: Mock Fail Session
class MockFailSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let jsonString =  """
{
  
}
"""
        let data = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: Constants.CellIdentifier.tramCell)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        completionHandler(data, response, nil)
        
        return MockURLSessionDataTask()
    }
}
