//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 31/01/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateToDoDelegate {
    
    var items:[ToDoItem] = []
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        
        println(ToDoListViewController.classForCoder().description())
        createInitialData()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
        
        tableview.setEditing(!tableview.editing, animated: true)
      
        
    }
 
    @IBAction func addButtonPressed(sender: AnyObject) {
        
       /*
        var toDoItem = ToDoItem(title: "Element ")
        toDoItem.note = "new note"
        toDoItem.color = UIColor.redColor()
        items.append(toDoItem)
        var indexPath = NSIndexPath (forRow: items.count - 1, inSection: 0)
        tableview.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        */
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreateToDo"{
            
            var navigationController = segue.destinationViewController as UINavigationController
            var createToDoViewController = navigationController.topViewController as CreateToDoViewController
            createToDoViewController.delegate = self
            
        }
    }
    // Mark: CreateToDoDelegate
    
    func createToDoDidCreateItem(todo: ToDoItem) {
        items.append(todo)
        var indexPath = NSIndexPath (forRow: items.count - 1, inSection: 0)
        tableview.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ToDoCustomCell") as ToDoTableViewCell
        
        cell.titleLabel?.text = items[indexPath.row].title
        cell.noteLabel?.text = items[indexPath.row].note
        cell.colorIndicatorView?.backgroundColor = items[indexPath.row].color
        if items[indexPath.row].done{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Selected cell \(indexPath.row+1)")
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
        items[indexPath.row].color = UIColor.greenColor()
        items[indexPath.row].done = true
        tableview.reloadData()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        var toDoItem = items[sourceIndexPath.row]
        items.removeAtIndex(sourceIndexPath.row)
        items.insert(toDoItem, atIndex: destinationIndexPath.row)
        
    }
    
    
    
    // MARK: - Private Methods
    
    func createInitialData(){
        
        items.append(ToDoItem(title: "first element"))
        items.append(ToDoItem(title: "second element"))
        items.append(ToDoItem(title: "thirth element"))
        println(items[0].title)
        
        
    }
    
 
}

// MARK: - Custom Class
class ToDoItem {
    var title = ""
    var done = false
    var note = ""
    var color = UIColor.lightGrayColor()
    
    init(title: String, note: String, color: UIColor){
        self.title = title
        self.note = note
        self.color = color
    }
    
    init(title: String){
        self.title = title
     
    }
    
}
    
class ToDoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var colorIndicatorView: UIView!
 
        
}


