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
        // Do any additional setup after loading the view, typically from a nib.
    }

 var itemArray = ["do first thing" , "do second", "do third"]
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
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

