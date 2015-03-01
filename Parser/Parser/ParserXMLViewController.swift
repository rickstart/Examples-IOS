//
//  ParserXMLViewController.swift
//  Parser
//
//  Created by MobileStudio04 on 28/02/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit

let kXMLBooksURL = "http://mobilestudio.mx/iphone/parser/books.php"

class ParserXMLViewController: UIViewController, NSXMLParserDelegate{

    var auxBook: Book?
    var auxString: String?
    var booksArray: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
    }
    
    func loadBooks(){
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFXMLParserResponseSerializer()
        let param = ["type" : "XML" ]
        
        manager.POST(kXMLBooksURL, parameters: param, success: { (success:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            //if is success the petition
            println(responseObject.description)
            let xmlParserObject = responseObject as NSXMLParser
            xmlParserObject.delegate = self
            xmlParserObject.parse()
            println(self.booksArray)
            for book in self.booksArray{
                println(book.title)
            }
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            //if fail petition
             println(error.localizedDescription)
        })
        
        
        
    }
    //MARK: - NSXMLParserDelegate
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        //when the parser found new element
        
        if elementName == kBook{
            auxBook = Book()
            auxBook?.bookId = attributeDict[kBookId] as String
        }
        
        auxString = ""
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        // when the function found the value of the tag
        
        auxString = auxString! + string
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        //is call when the parser found the end of a element
        
        switch(elementName){
            case kAuthor:
                auxBook?.author = auxString!
                
                break
            case kTitle:
                auxBook?.title = auxString!
                break
            case kGenre:
                auxBook?.genre = auxString!
                break
            case kPrice:
                auxBook?.price = auxString!
                break
            case kPublishDate:
                auxBook?.publishDate = auxString!
                break
            case kDescription:
                auxBook?.description = auxString!
                break
            case kBook:
                booksArray.append(auxBook!)
            break
            default:
                println("default")
            break
    
            
            
        }
        
        
        auxString = ""
     
    }
    
    
}