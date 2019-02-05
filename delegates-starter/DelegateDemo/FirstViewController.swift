//
//  FirstViewController.swift
//  DelegateDemo
//
//  Created by Adriana González Martínez on 1/7/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import UIKit

//Step 4: Adopting the protocol

class FirstViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Step 5: Creating a reference of SecondViewController specifying the delegate
        if segue.identifier == "SecondViewSegue"{
            let secondVC = segue.destination as! SecondViewController
            secondVC.colorChange = { [weak self] (color) in
                self!.view.backgroundColor = color
            }
        }
    }

    //Step 6: Use the method of the protocol
    
    
}

