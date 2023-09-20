//
//  ViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/17/1402 AP.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        
        loadData()

        }
    //MARK: - table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        //MARK: - cell animation
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.5, delay: 0.03*Double(indexPath.row),animations: {
//                    cell.alpha = 1
//                })
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark:.none
//       ternary operator : value = condition ? valueIfTrue :valueIfFalse
        
        return cell
    }
  
        
    //MARK: -table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveTheData()
        
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }


    //MARK: - add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldText = UITextField()

        let alert = UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { action in
            if textFieldText.text! == ""{
                action.isEnabled=false
            }else{
                let newItem = Item(context: self.context)
                    
                newItem.title = textFieldText.text!
            self.itemArray.append(newItem)
                
                self.saveTheData()
            
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { alertTextField in
          alertTextField.placeholder = "creat new item"
          
         textFieldText = alertTextField
            
                
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: - swipe action
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "delete") { action, view, handler in
        
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            handler(true)
            self.saveTheData()
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //MARK: - funcs
    

    func saveTheData() {
       
        do {
            try
            context.save()
       
        }catch{
            print("error saving context \(error)")
        }
    }
    func loadData(with request:NSFetchRequest<Item>=Item.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{print("error fetching data from database")}
    }
   
}
//MARK: - search bar delegate

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item>=Item.fetchRequest()
        
        request.predicate  = NSPredicate(format: "(title CONTAINS[cd] %@) ", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadData(with: request)
        searchBar.setShowsCancelButton(true, animated: true)

        searchBar.endEditing(true)
        
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        loadData()
        
        
    }
}
