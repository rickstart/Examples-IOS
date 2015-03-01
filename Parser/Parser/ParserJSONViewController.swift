//
//  ParserJSONViewController.swift
//  Parser
//
//  Created by MobileStudio04 on 28/02/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit

class ParserJSONViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var booksTableView: UITableView!
    var bookArray:[Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
    }
    
    func loadBooks(){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(kXMLBooksURL, parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            //Success Petition
            
            //println(responseObject)
            
            if let responseDict = responseObject as? NSDictionary {
                if let catalogDict = responseDict["catalog"] as? NSDictionary{
                    if let booksArray = catalogDict["books"] as? NSArray{
                        for bookDict in booksArray{
                            println(bookDict.description)
                            let book = Book(dictionary: bookDict as NSDictionary)
                            self.bookArray.append(book)
                            
                        }
                        
                        //println(self.bookArray)
                        self.booksTableView.reloadData()
                        
                    }
                }
            }
            
            }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            //Fail the petition
                println(error.localizedDescription)
            
        
        })
    }
    
    //MARK: -TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.bookArray.count)
        return self.bookArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BookCustomCell") as BookTableViewCell
        
        cell.titleLabel?.text = self.bookArray[indexPath.row].title
        cell.authorLabel?.text = self.bookArray[indexPath.row].author
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        booksTableView.deselectRowAtIndexPath(indexPath, animated: true)
        //bookArray[indexPath.row].title = "ok"
        booksTableView.reloadData()
        
    }
    
   
 

}

//MARK: -TableCell

class BookTableViewCell: UITableViewCell {
   
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var title=""
    
}


