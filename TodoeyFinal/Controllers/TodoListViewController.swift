//
//  ViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/17/1402 AP.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        }
    //MARK: - table viw data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark:.none
        
        
        return cell
    }
    //MARK: -table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveTheData()
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
                let newItem = Item()
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
    func saveTheData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("error decoding item array\(error)")
        }
    }
    func loadData(){
        do{
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            try itemArray = decoder.decode([Item].self, from: data)
        }catch{print("error decoding")}
    }
}

