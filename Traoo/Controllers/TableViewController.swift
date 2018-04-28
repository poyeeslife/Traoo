//
//  ViewController.swift
//  Traoo
//
//  Created by PoYee Tam on 12/2/2018.
//  Copyright © 2018年 PoYee Tam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//
//            itemArray = items}
//
        // if statement becoz if theres no saved data on todolistarray, app will crashed.
    }

// var itemArray = ["do first thing" , "do second", "do third"]
     var itemArray = [Item]()
    // make the item array of an array of item.swift file (DataModel) object

//    let defaults = UserDefaults.standard
    // var becoz we need to add something..
    
    //MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        //****   .title becoz now the itemArray is no longer string.. it's a dictionary with title and done property
        
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        //        ternary operator   structure:  value = condition? value if true: value if false (not in boolean...it's kind of if statement)
        //equals to ::::    if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//
//        }
        return cell
    }
//MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        didSelectRow is used to detect which row we are at
        // print (itemArray[indexPath.row])

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //      **menas set it to the opposite value..only works on boolean, this line equals to:  if itemArray[indexPath.row].done == false { itemArray[indexPath.row].done = true }
//        else {itemArray[indexPath.row].done = false}
        saveItems()
//        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//           tableView.cellForRow(at: indexPath)?.accessoryType = .none}
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
//        //grabbing a reference to the cell that is at a particular indexpath
        
        
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
            
            self.saveItems()
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            print(textfield.text)
            
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)

            self.saveItems()
                    
            }
            
//            which will encode our data namely our itemArray into a property list
            
            
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
////            //key is use to identify the array in user defaults
            self.tableView.reloadData()
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)

            try data.write (to: dataFilePath!)
        }
        catch { print ("Error encoding item array, \(error)")
            
        }
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder ()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error occured when decoding")
                
            }
        
    }
}


// use the saved items to load up our tableview fto load up all the data
// we can view our data inside our user default and we can prove that the data has been saved
//user def gets saved in a plist file.. thats why everything we saved need to be a key-value pair.. we need a key (i.e. "ToDoListArray" to retrieve the item and then add a value of any type (e.g. string/dictionary/array)
// need to run in viewDiDLoad

}
