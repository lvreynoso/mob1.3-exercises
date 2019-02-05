//
//  SelectorButton.swift
//  selector-practice
//
//  Created by Lucia Reynoso on 1/31/19.
//  Copyright © 2019 Lucia Reynoso. All rights reserved.
//

import UIKit

class SelectorButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var params: Dictionary<String, Int>
    
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
        self.params["TheAnswer"] = 42
        self.params["SantaCruz"] = 420
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
        self.params["TheAnswer"] = 42
        self.params["SantaCruz"] = 420
    }
    
}
