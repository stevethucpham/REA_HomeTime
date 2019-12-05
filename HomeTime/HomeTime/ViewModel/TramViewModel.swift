//
//  TramViewModel.swift
//  HomeTime
//
//  Created by iOS Developer on 12/4/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

// MARK: Tram View Model Type
protocol TramViewModelType {
    
    /// This method used to clear all data
    func clearTramData()
    
    /// This function is used to load tram data of the stop ID 4055 for the North and 4155 for the South.
    func loadTramData()
    
    /// Get the number of trams in the North
    func getNorthTramsCount() -> Int
    
    /// Get the number of trams in the South
    func getSouthTramsCount() -> Int
    
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


// MARK: Tram View Model
class TramViewModel: TramViewModelType {
    private var northTrams: [TramData]?
    private var southTrams: [TramData]?
    let service: TramServiceType
    private var loadingNorth: Bool = false
    private var loadingSouth: Bool = false
    
    init(service: TramServiceType = TramService()) {
        self.service = service
    }
    
    // MARK: Input

    func clearTramData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
        guard let reloadTable = self.reloadTable else { return }
        reloadTable()
    }
    
    func getNorthTramsCount() -> Int {
        if let northTrams = northTrams {
            return northTrams.count
        }
        return 1
    }

    func getSouthTramsCount() -> Int {
        if let southTrams = southTrams {
            return southTrams.count
        }
        return 1
    }
    
    func getTramNumber(at indexPath: IndexPath) -> String {
        guard let trams = tramsFor(section: indexPath.section) else {
            return ""
        }
        return "Route: \(trams[indexPath.row].routeNo ?? "")"
    }
    
    func getTramArrivalTime(at indexPath: IndexPath) -> String {
        let trams = tramsFor(section: indexPath.section)
        
        guard (trams?[indexPath.row]) != nil else{

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
        let trams = tramsFor(section: indexPath.section)
        let dateConverter = DotNetDateConverter()
        guard let arrivalTime = trams?[indexPath.row].predictedArrivalDateTime, let tramTime = dateConverter.dateFromDotNetFormattedDateString(arrivalTime) else {
          return ""
        }
        return " (\(tramTime.timeDifference(since: sinceTime)))"
    }
    
    func getDestination(at indexPath: IndexPath) -> String {
        guard let trams = tramsFor(section: indexPath.section) else {
            return ""
        }
        return trams[indexPath.row].destination ?? "Melbourne"
    }

    
    func loadTramData() {
        let northStopId = "4055"
        let southStopId = "4155"
        startLoading()
        service.loadTramDataUsing(stopId: northStopId) { [weak self] (result) in
            switch result {
            case .success(let trams):
                self?.stopLoadingNorth()
                self?.northTrams = trams
                
                break
            case .failure(let error):
                debugPrint(error?.localizedDescription ?? "Something went wrong")
                guard let showAlert = self?.showAlertClosure else { return }
                showAlert(error?.localizedDescription ?? "Something went wrong")
                break
            }
            guard let reloadTable = self?.reloadTable else { return }
            reloadTable()
        }
        
        service.loadTramDataUsing(stopId: southStopId) { [weak self] (result) in
            switch result {
            case .success(let trams):
                self?.stopLoadingSouth()
                self?.southTrams = trams
                break
            case .failure(let error):
                print(error?.localizedDescription ?? "Something went wrong")
                guard let showAlert = self?.showAlertClosure else { return }
                showAlert(error?.localizedDescription ?? "Something went wrong")
                break
            }
            guard let reloadTable = self?.reloadTable else { return }
            reloadTable()
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
    
    private func tramsFor(section: Int) -> [TramData]? {
        return (section == 0) ? northTrams : southTrams
    }
}
