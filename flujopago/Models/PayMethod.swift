//
//  PayMethod.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/22/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import Foundation
import UIKit

class PayMethod: Decodable {
    var id: String?
    var name: String?
    var payment_type_id: String?
    var secure_thumbnail: String?
    var imageData: Data?
    var image: UIImage? {
        get{
            if let imageData = imageData{
                return UIImage(data: imageData as Data)
            }else{
                return nil
            }
        }
        set{
            if let newValue = newValue {
                imageData = UIImagePNGRepresentation(newValue)
            }else{
                imageData = nil
            }
        }
        
    }
    //TODO: Agregar mas propiedades para efectos de validacion
    //y precision en la seleccion de una tarjeta o medio de pago
}
