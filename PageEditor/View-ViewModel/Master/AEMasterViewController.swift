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
    
    // MARK: - ViewModel
    private let viewModel = AEMasterViewModel()
    
    // MARK: - AEMasterViewController Override Methods
    override func viewDidLoad() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = addButton
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlDidPull(_:)), for: .valueChanged)
        
        self.tableView.register(.masterArticleCell, forCellReuseIdentifier: AEMasterTableViewCell.identifier)
        
        viewModel.viewDidLoad(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
    }
    
    // MARK: - IB Actions
    @objc func insertNewObject(_ sender: Any) {
        let titleAlert = UIAlertController(title: "タイトルを入力してください。",message: nil, preferredStyle: .alert)
        titleAlert.addTextField{textField in
            textField.placeholder = "タイトル"
        }
        titleAlert.addCancel()
        titleAlert.addAction(title: "作成"){
            let title = titleAlert.textFields![0].text!
            self.viewModel.createNewArticle(for: title)
        }
        
        self.present(titleAlert, animated: true)
    }
    
    @objc func refreshControlDidPull(_ sender:UIRefreshControl){
        viewModel.reloadArticles()
    }
}

// MARK: - UITableViewController Override Methods

extension AEMasterViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AEMasterTableViewCell.identifier, for: indexPath) as! AEMasterTableViewCell
        let cellData = viewModel.cellData(for: indexPath.row)
        
        cell.setTitle(cellData.title)
        cell.setSubtitle(cellData.subTitle)
        cell.setImage(cellData.imageData.flatMap{UIImage(data: $0)})
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeArticle(at: indexPath.row)
        }
    }
}

// MARK: - ViewModel Binding Methods

extension AEMasterViewController: AEMasterViewModelBinder{
    func reloadAllData() {
        self.tableView.reloadData()
    }
    func reloadData(at indexes: [Int]) {
        self.tableView.reloadRows(at: indexes.map{IndexPath(row: $0, section: 0)}, with: .automatic)
    }
    func changeEditMode(on: Bool) {
        self.tableView.setEditing(on, animated: true)
    }
    func removeItem(at index: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    func showAlert(with message:String){
        let alert = UIAlertController(title: "通知", message: message, preferredStyle: .alert)
        alert.addAction(title: "OK") {}
        
        self.present(alert, animated: true)
    }
}
