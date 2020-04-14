//
//  TramViewModel.swift
//  HomeTime
//
//  Created by iOS Developer on 12/4/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Tram View Model Type
protocol TramViewModelType {
    
    /// This method used to clear all data
    func clearTramData()
    
    /// This function is used to load tram data of the stop ID 4055 for the North and 4155 for the South.
    func loadTramData()
    
    func getTramCount(index: Int) -> Int
    
    func getStopDirection(section: Int) -> String
    
//    /// Get the number of trams in the North
//    func getNorthTramsCount() -> Int
//
//    /// Get the number of trams in the South
//    func getSouthTramsCount() -> Int
    
    /// Get the route number of tram for the table view cell
    /// - Parameter indexPath: the table index path
    func getTramNumber(at indexPath: IndexPath) -> String
    
    ///  Get the arrival time of the tram for the table view cell
    /// - Parameter indexPath: the table index path
    func getTramArrivalTime(at indexPath: IndexPath) -> String
    
    ///  Get the time interval between the arrival time and current time for the table view cell
    /// - Parameter indexPath: the table index path
    /// - Parameter sinceTime: time to compare
    func getTimeInterval(at indexPath: IndexPath, sinceTime: Date) -> String
    
    ///  Get the destination of the tram for the table view cell
    /// - Parameter indexPath: the table index path
    func getDestination(at indexPath: IndexPath) -> String
    
    /// The callback to show alert when with error message
    var showAlertClosure: ((String)->())? { get set }

    /// Callback to reload table when data is loaded
    var reloadTable: (()->())? { get set }
}

enum LoadingStatus {
    case loaded
    case loading
    case none
}

struct Stop {
    var direction: String
    var stopId: String
    var tramlist: [TramData]?
    var status: LoadingStatus = .none
}


// MARK: Tram View Model
class TramViewModel: TramViewModelType {

    let service: TramServiceType
    private var loadingNorth: Bool = false
    private var loadingSouth: Bool = false
    private var stops: [Stop] = [
        Stop(direction: "North", stopId: "4055", tramlist: nil),
        Stop(direction: "South", stopId: "4155", tramlist: nil)
    ]
    
    init(service: TramServiceType = TramService()) {
        self.service = service
    }
    
    // MARK: Input

    func clearTramData() {
        guard let reloadTable = self.reloadTable else { return }
        reloadTable()
    }
    
    func getTramCount(index: Int) -> Int {
        return stops[index].tramlist?.count ?? 1
    }
    
    func getStopDirection(section: Int) -> String {
        return stops[section].direction
    }
    
    func getTramNumber(at indexPath: IndexPath) -> String {
        guard let trams = stops[indexPath.section].tramlist else {
            return ""
        }
        return "Route: \(trams[indexPath.row].routeNo ?? "")"
    }
    
    func getTramArrivalTime(at indexPath: IndexPath) -> String {
        let trams = stops[indexPath.section].tramlist
        
        guard (trams?[indexPath.row]) != nil else {

            if isLoading(section: indexPath.section) {
                return "Loading upcoming trams..."
            } else {
                return "No upcoming trams. Tap load to fetch"
            }
        }
        
        guard let arrivalDateString = trams?[indexPath.row].predictedArrivalDateTime else {
          return ""
        }
        let dateConverter = DotNetDateConverter()
        return dateConverter.formattedDateFromString(arrivalDateString)
    }
    
    func getTimeInterval(at indexPath: IndexPath, sinceTime: Date) -> String {
        let trams = stops[indexPath.section].tramlist
        let dateConverter = DotNetDateConverter()
        guard let arrivalTime = trams?[indexPath.row].predictedArrivalDateTime, let tramTime = dateConverter.dateFromDotNetFormattedDateString(arrivalTime) else {
          return ""
        }
        return " (\(tramTime.timeDifference(since: sinceTime)))"
    }
    
    func getDestination(at indexPath: IndexPath) -> String {
        guard let trams = stops[indexPath.section].tramlist else {
            return ""
        }
        return trams[indexPath.row].destination ?? "Melbourne"
    }
    
    
    func loadTramData() {
//        let northStopId = "4055"
//        let southStopId = "4155"
        startLoading()
        
        
        for (key,var item) in stops.enumerated() {
            service.loadTramDataUsing(stopId: item.stopId) { [weak self] (result) in
                switch result {
                case .success(let tramData):
                    item.tramlist = tramData
                    // TODO: Update the stops
                    self?.stops[key].tramlist = item.tramlist
                    guard let reloadTable = self?.reloadTable else { return }
                    reloadTable()
                    break
                case .failure(let error) :
                    guard let showAlert = self?.showAlertClosure else { return }
                    showAlert(error?.localizedDescription ?? "Something went wrong")
                    break
                }
            }
        }

    }
    
    // MARK: Output
    var showAlertClosure: ((String) -> ())?
    var reloadTable: (()->())?

    // MARK: Private functions
    
    private func startLoading() {
        loadingNorth = true
        loadingSouth = true
    }
    
    private func stopLoadingNorth() {
        loadingNorth = false
    }
    
    private func stopLoadingSouth() {
        loadingSouth = false
    }
    
    private func isLoading(section: Int) -> Bool {
        return (section == 0) ? loadingNorth : loadingSouth
    }

}
