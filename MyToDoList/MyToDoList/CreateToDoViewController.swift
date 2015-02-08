//
//  CreateToDoViewController.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 07/02/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//


import UIKit
protocol CreateToDoDelegate{
    func createToDoDidCreateItem(todo: ToDoItem)
}

class CreateToDoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SelectColorDelegate {
    
    var delegate: CreateToDoDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    var colors = ["Red","Yellow","Green","Blue"]
    var priority = ["Low","Medium","High"]
    var prioritySelected: String = "Low"
    var col: UIColor = UIColor.grayColor()
    
    @IBOutlet weak var colorButton: UIButton!
    
    override func viewDidLoad() {
        
    
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectColor"{
            
            var selectColorViewController = segue.destinationViewController as SelectColorViewController
            selectColorViewController.delegate = self
            
        }
    }
    @IBAction func addButtonPressed(sender: AnyObject) {
 
        let title = titleTextField.text
        let subtitle = subtitleTextField.text
        if !title.isEmpty{
            
            
            
            var toDoItem = ToDoItem(title: titleTextField.text,note: subtitle,color: col)
            delegate?.createToDoDidCreateItem(toDoItem)
            self.dismissViewControllerAnimated(true, completion: nil)
           
        } else {
            println("Error")
            let alertController = UIAlertController(title: "Error", message: "Have to write at least a title", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(actionOk)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
      
        
       // ToDoListViewController.items.append(toDoItem)
       
        
        
        
        
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Mark: DataSource Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priority.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        println(priority[row])
        prioritySelected = priority[row]
        
        switch(prioritySelected){
        case "Low":
            col = UIColor.grayColor()
            colorButton.backgroundColor = col
            break
        case "Medium":
            col = UIColor.orangeColor()
            colorButton.backgroundColor = col
            break
        case "High":
            col = UIColor.redColor()
            colorButton.backgroundColor = col
            break
        default:
            col = UIColor.greenColor()
            break
            
        }
        
        return priority[row]
        
        
    }
    
    //Mark: - SelectColorDelegate
    
    func selectColorDidSelectColor(color: UIColor){
        println("Color received")
        
        colorButton.backgroundColor = color
        col = color
        
    }
}