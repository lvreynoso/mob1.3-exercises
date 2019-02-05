//
//  ViewController.swift
//  selector-practice
//
//  Created by Lucia Reynoso on 1/31/19.
//  Copyright © 2019 Lucia Reynoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: SelectorButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.params["Stephen"] = 99
        loginButton.params["Prince"] = 1999
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func login(sender: SelectorButton) {
        print(sender.params)
    }


}

