//
//  ViewController.swift
//  Traoo
//
//  Created by PoYee Tam on 12/2/2018.
//  Copyright © 2018年 PoYee Tam. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    
    
                        //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
                       //the above is used to save the plist
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        // the above is used to save data in CoreData
    
                        // var itemArray = ["do first thing" , "do second", "do third"]
    var itemArray = [Item]()
                        // make the item array of an array of item.swift file (DataModel) object
    
                        //    let defaults = UserDefaults.standard
                        // var becoz we need to add something..
    var selectedCategory : Category? {
        didSet{
            // didSet is a speical keyword. Everything between didSet is going to happen as soon as selectedCategory get set with a value.
            loadItems()
        }
    }
    // Category? is an optional because it is nil until we set it using  destinationVC.selectedCategory = categoryArray[indexPath.row]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        //        loadItems() <-- run when selectedCategory: Cateogory? is set.
        
        
                        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
                        //
                        //            itemArray = items}
                        //
                        // if statement becoz if theres no saved data on todolistarray, app will crashed.
    }

    
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
            
            textfield = alertTextField
            alertTextField.placeholder = "Create new item!"
            self.saveItems()
        }
        //alert.addTextField { this is the block of your textfield configuration handler!! (put the name of your textfield name.)}
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                        // what will happen once the user clicks the add item button on our UIAlert
            print(textfield.text)
            
                        //    let newItem = Item() <-- we dont use this because we no longer create a newItem by making an object from the Item class (i.e. Item() ), we now need to call our CoreData by the following code.
            
            let newItem = Item (context: self.context)
            newItem.title = textfield.text!
            newItem.done =  false
            newItem.toCategory = self.selectedCategory
            //we have this attribute because we have created the relationship inside DataModel
            self.itemArray.append(newItem)

            self.saveItems()
                    
            }
            
                        //            which will encode our data namely our itemArray into a property list
        
        
                        //            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                        //            key is use to identify the array in user defaults
            self.tableView.reloadData()
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
                        //        let encoder = PropertyListEncoder()  ****** delete this part becoz we no longer use Codable
                        //        do {
                        //            let data = try encoder.encode(itemArray)
                        //
                        //            try data.write (to: dataFilePath!)
                        //        }
                        //        catch { print ("Error encoding item array, \(error)")
                        //
                        //        }
        
        do{
            try context.save()
        } catch {
            print("Error saving the context. \(error)")
        }
        tableView.reloadData()
        
    }
                        
//                            func loadItems() {
//                                if let data = try? Data(contentsOf: dataFilePath!){
//                                    let decoder = PropertyListDecoder ()
//                                    do {
//                                    itemArray = try decoder.decode([Item].self, from: data)
//                                    } catch {
//                                        print ("Error occured when decoding")
//
//                                    }
//
//                            }
//                        } // this is example of encoding data saving method

 
    
    
    //下面：orgPredicate係再額外加上去嘅parameter..令到佢可以再parse一個data入去，但係由於search唔一定有，所以要set返佢default value 係nil...而且係optional..所以就出現 NSPredicate? = nil
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        
        let categoryPredicate = NSPredicate(format: "toCategory.name MATCHES[cd] %@", selectedCategory!.categoryName!)

        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!]) <--categoryPredicate and the predicate that parsed in as an argument.
        
//        request.predicate = compoundPredicate
      
        //下面means that if it is not nil..and has a value of predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        
        tableView.reloadData()
    }

    
    
//    func loadItems() {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//    }
                        // use the saved items to load up our tableview fto load up all the data
                        // we can view our data inside our user default and we can prove that the data has been saved
                        //user def gets saved in a plist file.. thats why everything we saved need to be a key-value pair.. we need a key (i.e. "ToDoListArray" to retrieve the item and then add a value of any type (e.g. string/dictionary/array)
                        // need to run in viewDiDLoad

}

extension TableViewController: UISearchBarDelegate{
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {searchBar.resignFirstResponder()}
        }
            else {
                let request: NSFetchRequest<Item> = Item.fetchRequest()
//                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = searchPredicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.loadItems(with: request, predicate: searchPredicate)
            }
    }
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    let request: NSFetchRequest<Item> = Item.fetchRequest()
//    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        loadItems(with: request)
//        print (searchBar.text!)
//    }
//
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }

