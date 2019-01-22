//
//  StepOneMountViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/15/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class StepOneMountViewController: UIViewController {
    
    // MARK: Properties
    var transaction: Transaction?
    var delegate: TransactionDelegate?
    
    @IBOutlet weak var mountTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mountTextField.delegate = self
        transaction = Transaction()
        continueButton.isEnabled = false
    }
    
    @IBAction func toPayMethods(_ sender: Any) {
        performSegue(withIdentifier: "segueStepOne", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepTwoPayMethod = segue.destination as? StepTwoPayMethodViewController {
            stepTwoPayMethod.delegate = self.delegate
            stepTwoPayMethod.transaction = self.transaction
        }
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            transaction?.mount = text.isEmpty ? 0 : Int(text)
            continueButton.isEnabled = !text.isEmpty
        }else{
            continueButton.isEnabled = false
        }
    }
    
}

extension StepOneMountViewController: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            transaction?.mount = text.isEmpty ? 0 : Int(text)
            continueButton.isEnabled = !text.isEmpty
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
