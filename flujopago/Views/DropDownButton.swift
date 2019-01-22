//
//  DropDownButton.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/17/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class DropDownButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
