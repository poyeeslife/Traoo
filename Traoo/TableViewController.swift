//
//  ViewController.swift
//  Traoo
//
//  Created by PoYee Tam on 12/2/2018.
//  Copyright © 2018年 PoYee Tam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
        
            itemArray = items}
        // if statement becoz if theres no saved data on todolistarray, app will crashed.
    }

 var itemArray = ["do first thing" , "do second", "do third"]
    let defaults = UserDefaults.standard
    // var becoz we need to add something..
    
    //MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
//MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        didSelectRow is used to detect which row we are at
        // print (itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none}
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //grabbing a reference to the cell that is at a particular indexpath
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        //等佢CLICK完淨係閃一閃。
    }
// MARK - make new item
    
    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
    //一整個alert就要做晒以下嘅野。
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add To Do Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item!"
            textfield = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            print(textfield.text)
            self.itemArray.append(textfield.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            //key is use to identify the array in user defaults
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

// use the saved items to load up our tableview to load up all the data
// we can view our data inside our user default and we can prove that the data has been saved
//user def gets saved in a plist file.. thats why everything we saved need to be a key-value pair.. we need a key (i.e. "ToDoListArray" to retrieve the item and then add a value of any type (e.g. string/dictionary/array)
// need to run in viewDiDLoad

