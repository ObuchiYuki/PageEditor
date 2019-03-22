//
//  AEEditorViewController.swift
//  PageEditor
//
//  Created by yuki on 2019/03/18.
//  Copyright © 2019 yuki. All rights reserved.
//

import UIKit

class AEEditorViewController: UITableViewController {
    let viewModel = AEEditorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(self)
        
        tableView.register(AEEditorParagraphCell.nib, forCellReuseIdentifier: AEEditorParagraphCell.identifier)
        tableView.register(AEEditorImageCell.nib, forCellReuseIdentifier: AEEditorImageCell.identifier)
        tableView.register(AEEditorHeadlineCell.nib, forCellReuseIdentifier: AEEditorHeadlineCell.identifier)
        tableView.register(AEEditorNameCell.nib, forCellReuseIdentifier: AEEditorNameCell.identifier)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidPush(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func addButtonDidPush(_ button:UIBarButtonItem){
        let actionSheet = UIAlertController(title: "要素を追加", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(title: "段落"){self.viewModel.addItem(for: .paragraph)}
        actionSheet.addAction(title: "画像"){self.viewModel.addItem(for: .image)}
        actionSheet.addAction(title: "見出し"){self.viewModel.addItem(for: .headline)}
        actionSheet.addAction(title: "署名"){self.viewModel.addItem(for: .name)}
        
        actionSheet.addCancel()
        
        actionSheet.popoverPresentationController?.barButtonItem = button
        
        self.present(actionSheet, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.cellData(for: indexPath.row)
        let identifier = viewModel.cellIdetifier(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AEEditorCell
        cell.setDefaultData(data)
        
        switch data.nodeType {
        case .paragraph:
            let data = data as! AEEditorParagraphCellData
            let cell = cell as! AEEditorParagraphCell
            
            cell.setText(data.text)

            return cell
        case .image:
            let data = data as! AEEditorImageCellData
            let cell = cell as! AEEditorImageCell
            
            cell.setImage(data.imageData.flatMap{UIImage(data: $0)})
            
            return cell
        case .headline:
            let data = data as! AEEditorHeadlineCellData
            let cell = cell as! AEEditorHeadlineCell
            
            cell.setTitle(data.text)
            cell.setLevel(data.level)
            
            return cell
        case .name:
            let data = data as! AEEditorNameCellData
            let cell = cell as! AEEditorNameCell
            
            cell.setName(data.text)
            
            return  cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight(for: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount()
    }
}
extension AEEditorParagraphCell{
    
}
extension AEEditorViewController: AEEditorViewModelBinder{
    func reloadCells(at rows: [Int]) {
        self.tableView.reloadRows(at: rows.map{IndexPath(row: $0, section: 0)}, with: .automatic)
    }
    func removeCell(at row: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    func reloadAllCells() {
        self.tableView.reloadData()
    }
    func appendCell(at row: Int) {
        self.tableView.insertRows(at: [[0, row]], with: .automatic)
    }
}
