//
//  TramTableCell.swift
//  HomeTime
//
//  Created by iOS Developer on 12/5/19.
//  Copyright © 2019 REA. All rights reserved.
//

import UIKit

class TramTableCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var routeNumberLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// This method is used to set value for the labels of the cell
    /// - Parameters:
    ///   - routeNo: tram route number
    ///   - arrivalTime: arrival time expected
    ///   - timeInterval: time interval
    ///   - destination: destination of the tram
    func setupCell(routeNo: String, arrivalTime: String, timeInterval: String, destination: String) {
        arrivalTimeLabel.text = arrivalTime
        routeNumberLabel.text = routeNo
        timeIntervalLabel.text = timeInterval
        destinationLabel.text = destination
    }
}
