//
//  Message.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/22/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import Foundation

class Cost: Decodable {
    var installments: Int?
    var recommended_message: String?
    var installment_amount: Double?
    var total_amount: Double?
    
}
