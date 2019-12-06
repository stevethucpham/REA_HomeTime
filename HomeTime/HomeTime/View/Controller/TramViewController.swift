//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit


class TramViewController: UITableViewController {
    
    // MARK: IBOutlets
    @IBOutlet var tramTimesTable: UITableView!
    
    var viewModel: TramViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TramViewModel()
        setupTableView()
        bindUI()
        
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.clearTramData()
    }
    
    @IBAction func loadButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.clearTramData()
        viewModel.loadTramData()
    }
    
    private func bindUI() {
        viewModel.reloadTable = { [weak self] () in
            DispatchQueue.main.async {
                self?.tramTimesTable.reloadData()
            }
        }
        
        viewModel.showAlertClosure = { [weak self] (message) in
            DispatchQueue.main.async {
                self?.alert(title: "Error", message: message, okButtonTitle: "Ok")
            }
        }
    }
    
    private func setupTableView() {
        self.tramTimesTable.tableFooterView = UIView()
        self.tramTimesTable.estimatedRowHeight = 600
        tramTimesTable.register(UINib(nibName: Constants.CellIdentifier.tramCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier.tramCell)
    }
}

// MARK: - UITableViewDataSource
extension TramViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.tramCell, for: indexPath) as! TramTableCell
        cell.setupCell(routeNo: viewModel.getTramNumber(at: indexPath), arrivalTime: viewModel.getTramArrivalTime(at: indexPath), timeInterval: viewModel.getTimeInterval(at: indexPath, sinceTime: Date()), destination: viewModel.getDestination(at: indexPath))
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return viewModel.getNorthTramsCount()
        }
        else
        {
            return viewModel.getSouthTramsCount()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "North" : "South"
    }
}
