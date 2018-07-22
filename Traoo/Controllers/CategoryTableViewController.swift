//
//  CategoryTableViewController.swift
//  Traoo
//
//  Created by PoYee Tam on 29/6/2018.
//  Copyright © 2018年 PoYee Tam. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].categoryName
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TableViewController
        
      if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        
        // if let - because indexPathForSelectedRow is an optional
    
    }
    // MARK: - Data Manipulation Methods
    
    func loadCategory () {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do { categoryArray = try context.fetch(request)}
        catch {print ("Error. \(error)")}
        tableView.reloadData()
    }
    
    func saveCategory() {
        do {try context.save()}
        catch {print("Error saving category. \(error)")}
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "Categorise your To Do Items", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category!"
            textfield = alertTextField
            
            self.saveCategory()
    }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category (context: self.context)
            newCategory.categoryName = textfield.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
        
    
   
    

}
