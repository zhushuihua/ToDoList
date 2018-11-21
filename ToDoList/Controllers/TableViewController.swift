//
//  ViewController.swift
//  ToDoList
//
//  Created by Shuihua Zhu on 21/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var items = [String]()
    var dones = [Bool]()
    let itemsKey = "itemsKey"
    let doneKey = "doneKey"
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: itemsKey) as? [String]
        {
            self.items = items
        }
        if let dones = defaults.array(forKey: doneKey) as? [Bool]
        {
            self.dones = dones
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.detailTextLabel?.text = items[indexPath.row]
        let done = dones[indexPath.row]
        cell.accessoryType = done ? .checkmark : .none
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        dones[indexPath.row] = !dones[indexPath.row]
        cell?.accessoryType = dones[indexPath.row] ? .checkmark : .none
        defaults.set(dones, forKey: doneKey)
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldx:UITextField!
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textFieldx = textField
            textField.placeholder = "Add New Item Here"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let str = textFieldx.text!
            self.items.append(str)
            self.dones.append(false)
            self.defaults.set(self.items, forKey:self.itemsKey)
            self.defaults.set(self.dones, forKey:self.doneKey)
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
}

