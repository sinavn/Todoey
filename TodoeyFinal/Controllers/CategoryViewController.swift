//
//  CategoryViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/24/1402 AP.
//

import UIKit
import RealmSwift
import SwipeCellKit
class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categoryArray : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no category added"
        cell.delegate = self
        return cell
    }
    //MARK: - add button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "new Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            if textField.text! == ""{
                action.isEnabled=false
            }else{
                let newCategory = Category()
                newCategory.name = textField.text!
//                newCategory.id = self.categoryArray!.count+1
                self.saveData(with: newCategory)
             
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "type new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: - table view delegation
   
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
//    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
////        tableView.reloadData()
//    }
    //MARK: - funcs
    func saveData(with category:Category) {
        do{
            try realm.write{
                realm.add(category)
            }
           
        }catch{ print("error saving data \(error)")}
        tableView.reloadData()
    }
    func loadData( ){
          categoryArray = realm.objects(Category.self)
       
    }
    //MARK: - swipe action
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deletAction = UIContextualAction(style: .normal, title: "delete") { action, view, handler in
//            try! self.realm.write {
//                if let safeCategory = self.categoryArray?[indexPath.row]{
//                    self.realm.delete(safeCategory)
//                }
//            }
//            handler(true)
//
//        }
//
//        deletAction.backgroundColor = .systemRed
//        return UISwipeActionsConfiguration(actions: [deletAction])
//    }

}
extension CategoryViewController : SwipeTableViewCellDelegate {
  
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let safeCategory = self.categoryArray?[indexPath.row]{
                try! self.realm.write {
                    self.realm.delete(safeCategory)
                }

            }
        }

        // customize the action appearance
        deleteAction.backgroundColor = .systemRed

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }

}
