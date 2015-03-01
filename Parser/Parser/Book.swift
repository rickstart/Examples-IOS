//
//  Book.swift
//  Parser
//
//  Created by MobileStudio04 on 28/02/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation

let kCatalog = "catalog"
let kBook = "book"
let kAuthor = "author"
let kTitle = "title"
let kGenre = "genre"
let kPrice = "price"
let kPublishDate = "publish_date"
let kDescription = "description"
let kBookId = "id"


class Book {
    
    var bookId=""
    var author=""
    var description = ""
    var genre = ""
    var price = "";
    var publishDate = ""
    var title = ""
    
    init(){}
    init(dictionary: NSDictionary){
        
        self.bookId = dictionary[kBookId] as String
        self.author = dictionary[kAuthor] as String
        self.description = dictionary[kDescription] as String
        self.genre = dictionary[kGenre] as String
        self.publishDate = dictionary[kPublishDate] as String
        self.title = dictionary[kTitle] as String
        
        
    }
    
    
}