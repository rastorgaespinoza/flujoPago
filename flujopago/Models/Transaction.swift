//
//  Transaction.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/19/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import Foundation

class Transaction {
    var id: String?
    //solo a modo de ejemplo preferí Int
    var mount: Int?
    var payMethod: PayMethod?
    var bank: Bank?
    var numFees: Int?
}
