//
//  ViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/17/1402 AP.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    var itemArray : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }

    let defaults = UserDefaults.standard
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
  

        }
    //MARK: - table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark:.none
            var content = cell.defaultContentConfiguration()
            content.text = "hello"
    //       ternary operator : value = condition ? valueIfTrue :valueIfFalse
            
            return cell
        }else{
            cell.textLabel?.text = "no item "
            return cell
        }
        //MARK: - cell animation
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.5, delay: 0.03*Double(indexPath.row),animations: {
//                    cell.alpha = 1
//                })
        
       
    }
  
        
    //MARK: -table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            try! realm .write{
                item.done = !item.done
            }
        }
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        saveTheData()
        
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
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textFieldText.text!
                            newItem.date = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{print("\(error)")}
       
                }
                
            
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { alertTextField in
          alertTextField.placeholder = "create new item"
          
         textFieldText = alertTextField
            
                
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: - swipe action
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "delete") { action, view, handler in
            if let safeItemArray = self.itemArray{
                try! self.realm.write{
                    self.realm.delete(safeItemArray[indexPath.row])
                }
                handler(true)
            }
         
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //MARK: - funcs
    

    func saveTheData(with item:Item) {
       
        do {
            try realm.write{
                realm.add(item)
            }
       
        }catch{
            print("error saving context \(error)")
        }
    }
    func loadData(){
         itemArray = selectedCategory?.items.sorted(byKeyPath: "title" , ascending: true)
    }
   
}
//MARK: - search bar delegate

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.endEditing(true)
        tableView.reloadData()
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
        tableView.reloadData()

    }
}
