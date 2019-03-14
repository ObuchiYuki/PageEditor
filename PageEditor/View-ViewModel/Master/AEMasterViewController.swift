//
//  AEMasterViewController.swift
//  PageEditor
//
//  Created by yuki on 2019/03/08.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

// MARK: - AEMasterViewController Class Definition
class AEMasterViewController: UITableViewController {
    
    let viewModel = AEMasterViewModel()
    
    override func viewDidLoad() {
        viewModel.viewDidLoad(self)
    }
    
    // MARK: - UITableViewController Override Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article_cell", for: indexPath)
        let cellData = viewModel.cellData(for: indexPath.row)
        
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.subTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}

extension AEMasterViewController: AEMasterViewModelBinder{
    func reloadAllData() {
        self.tableView.reloadData()
    }
    func reloadData(at indexes: [Int]) {
        self.tableView.reloadRows(at: indexes.map{IndexPath(row: $0, section: 0)}, with: .automatic)
    }
}
