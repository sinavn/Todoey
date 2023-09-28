//
//  SwipeTableViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 7/3/1402 AP.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController , SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - tableView data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(with: indexPath)
        }
        let editAction = SwipeAction(style: .default, title: "edit") { action, indexPatch in
            self.editModelColor(with: indexPath)
            
        }

        // customize the action appearance
        deleteAction.backgroundColor = .systemRed
        editAction.backgroundColor = .systemGray
        return [deleteAction , editAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
   
    func updateModel (with indexPath:IndexPath){
        
    }
    func editModelColor (with indexPath:IndexPath){
        
    }
}
