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
    var items = [Item]()
    let itemsKey = "itemsKey"
    let pListPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = items[indexPath.row]
        let done = item.done
        cell.accessoryType = done ? .checkmark : .none
        cell.textLabel?.text = item.title
        if let date = item.finishDate
        {
            cell.detailTextLabel?.text = "\(date)"
        }
        else
        {
            cell.detailTextLabel?.text = "Ongoing"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        items[indexPath.row].done = !items[indexPath.row].done
        cell?.accessoryType = items[indexPath.row].done ? .checkmark : .none
        items[indexPath.row].finishDate = items[indexPath.row].done ? Date() : nil
        if let date = items[indexPath.row].finishDate
        {
            cell?.detailTextLabel?.text = "\(date)"
        }
        else
        {
            cell?.detailTextLabel?.text = "Ongoing"
        }
        saveList()
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
            let item = Item()
            item.title = str
            self.items.append(item)
            self.tableView.reloadData()
            self.saveList()
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    private func loadList(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: pListPath!)
        {
          if let  items = try? decoder.decode([Item].self, from: data)
            {
                self.items = items
                tableView.reloadData()
            }
        }
    }
    private func saveList(){
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(items)
        {
            try? data.write(to: pListPath!)
        }
    }
}

