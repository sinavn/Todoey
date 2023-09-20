//
//  CategoryViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/24/1402 AP.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Categoryy]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
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
                let newCategory = Categoryy(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveData()
             
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
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: Any?.self)
        
    }
    //MARK: - funcs
    func saveData() {
        do{
            try context.save()
           
        }catch{ print("error saving data \(error)")}
        tableView.reloadData()
    }
    func loadData(with request:NSFetchRequest<Categoryy> = Categoryy.fetchRequest() ){
        do{
            categoryArray = try context.fetch(request)
            tableView.reloadData()
        }catch{print("error fetching data \(error)")}
    }
    //MARK: - swipe action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deletAction = UIContextualAction(style: .normal, title: "delete") { action, view, handler in
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            handler(true)
            self.saveData()
        }
        
        deletAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deletAction])
    }

}

