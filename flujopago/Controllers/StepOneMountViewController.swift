//
//  StepOneMountViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/15/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class StepOneMountViewController: UIViewController {
    
    // MARK: - Properties
    var transaction: Transaction?
    var delegate: TransactionDelegate?
    
    @IBOutlet weak var mountTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transaction = Transaction()
        
        mountTextField.delegate = self
        continueButton.isEnabled = false
        
        //Utilizado para cerrar teclado al hacer tap fuera del cuadro de texto
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(StepOneMountViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    //Cierra el teclado al hacer tap en la pantalla.
    //extract from https://stackoverflow.com/questions/27878732/swift-how-to-dismiss-number-keyboard-after-tapping-outside-of-the-textfield
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    @IBAction func toPayMethods(_ sender: Any) {
        performSegue(withIdentifier: "segueStepOne", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        transaction = nil
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepTwoPayMethod = segue.destination as? StepTwoPayMethodViewController {
            stepTwoPayMethod.delegate = self.delegate
            stepTwoPayMethod.transaction = self.transaction
        }
    }

    //Se encarga de verificar si campo de texto tiene caracteres para habilitar botón Continuar
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            transaction?.mount = text.isEmpty ? 0 : Int(text)
            continueButton.isEnabled = !text.isEmpty
        }else{
            continueButton.isEnabled = false
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension StepOneMountViewController: UITextFieldDelegate{
    
    //Revisa que el texto ingresado sean solo caracteres numericos
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
    
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
