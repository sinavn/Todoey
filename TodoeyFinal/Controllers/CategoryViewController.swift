//
//  CategoryViewController.swift
//  TodoeyFinal
//
//  Created by SinaVN on 6/24/1402 AP.
//

import UIKit
import RealmSwift
import SwiftUI

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    let colorPicker = UIColorPickerViewController()
    var indexForColor : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.delegate = self
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no category added"
        
        if let color = categoryArray?[indexPath.row].color{
            let hexColor = UIColor(rgbaString : color)
            cell.backgroundColor = hexColor
        }
       
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
                self.saveData(with: newCategory)
            }
//            self.present(colorPicker , animated: true)
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "type new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
//      second view beside alert
//        let scrollView = UIScrollView(frame: CGRect(x: 280, y: 0, width: 25, height:150 ))
//        scrollView.layer.cornerRadius = 1.0
//        scrollView.clipsToBounds = true
//        scrollView.contentSize = CGSize(width: 100, height: 200)
//        scrollView.backgroundColor = .systemRed
//        alert.view.addSubview(scrollView)
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
    override func updateModel(with indexPath: IndexPath) {
        if let safeCategory = self.categoryArray?[indexPath.row]{
            try! self.realm.write {
                self.realm.delete(safeCategory)
            }

        }
    }
    override func editModelColor(with indexPath: IndexPath) {
        present(colorPicker,animated: true)
        indexForColor=indexPath.row
    }
}
//MARK: - ui color delegate

extension CategoryViewController : UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let colorSelected = viewController.selectedColor.toRGBAString()
        try! realm.write{
            categoryArray![indexForColor].color = colorSelected
        }
        let a = viewController.selectedColor.description
        print(a)
        tableView.reloadData()
    }
}

//MARK: - COLOR FORMAT INVERTER


extension UIColor {


   //Convert RGBA String to UIColor object
   //"rgbaString" must be separated by space "0.5 0.6 0.7 1.0" 50% of Red 60% of Green 70% of Blue Alpha 100%
   public convenience init?(rgbaString : String){
       self.init(ciColor: CIColor(string: rgbaString))
   }

   //Convert UIColor to RGBA String
   func toRGBAString()-> String {

       var r: CGFloat = 0
       var g: CGFloat = 0
       var b: CGFloat = 0
       var a: CGFloat = 0
       self.getRed(&r, green: &g, blue: &b, alpha: &a)
       return "\(r) \(g) \(b) \(a)"

   }
  
}
