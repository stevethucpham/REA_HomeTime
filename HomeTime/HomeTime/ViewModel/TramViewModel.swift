//
//  TramViewModel.swift
//  HomeTime
//
//  Created by iOS Developer on 12/4/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation


protocol TramViewModelType {
    func clearTramData()
    func loadTramData()
    func getNorthTramsCount() -> Int
    func getSouthTramsCount() -> Int
    func getTramNumber(at indexPath: IndexPath) -> String
    func getTramArrivalTime(at indexPath: IndexPath) -> String
    func getTimeInterval(at indexPath: IndexPath) -> String
    func getDestination(at indexPath: IndexPath) -> String
    var showAlertClosure: ((String)->())? { get set }
    var reloadTable: (()->())? { get set }
}

class TramViewModel: TramViewModelType {
   
    
   
    private var northTrams: [TramData]?
    private var southTrams: [TramData]?
    let service: TramServiceType
    private var loadingNorth: Bool = false
    private var loadingSouth: Bool = false
    
    init(service: TramServiceType = TramService()) {
        self.service = service
        loadTramData()
    }
    
    // MARK: Input
    /// This method used to clear all data
    func clearTramData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
        guard let reloadTable = self.reloadTable else { return }
        reloadTable()
    }
    
    /// This method is used to get the number of trams in the North
    func getNorthTramsCount() -> Int {
        if let northTrams = northTrams {
            return northTrams.count
        }
        return 1
    }
    
    /// This method is used to get the number of trams in the South
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
    
    func getTimeInterval(at indexPath: IndexPath) -> String {
        let trams = tramsFor(section: indexPath.section)
        let dateConverter = DotNetDateConverter()
        guard let arrivalTime = trams?[indexPath.row].predictedArrivalDateTime, let tramTime = dateConverter.dateFromDotNetFormattedDateString(arrivalTime) else {
          return ""
        }
        return " (\(Date().timeDifference(since: tramTime)))"
    }
    
    func getDestination(at indexPath: IndexPath) -> String {
        guard let trams = tramsFor(section: indexPath.section) else {
            return ""
        }
        return trams[indexPath.row].destination ?? "Melbourne"
    }
    
    /// This method is used to get the text for table view cell from the *TramData* and return appropriate text
    /// - Parameter indexPath: the cell indexPath
    func getTramText(at indexPath: IndexPath) -> String {
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
        return dateConverter.formattedDateFromString(arrivalDateString).lowercased()
    }
    
    /// This function is used to load tram data of the stop ID 4055 for the North and 4155 for the South.
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
