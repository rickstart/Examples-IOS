//
//  SelectColorViewController.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 07/02/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import UIKit

protocol SelectColorDelegate{
    func selectColorDidSelectColor(color: UIColor)
}


class SelectColorViewController: UIViewController {
    
    var delegate: SelectColorDelegate?
    
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func colorButtonPressed(sender: UIButton) {
        var color = sender.backgroundColor
        
        delegate?.selectColorDidSelectColor(color!)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
