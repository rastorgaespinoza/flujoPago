//
//  StepFourFeeViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/15/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

protocol TransactionDelegate{
    func sendTransaction(_ transaction: Transaction?)
}

class StepFourFeeViewController: UIViewController {

    var transaction: Transaction?
    var delegate: TransactionDelegate?
    var costDataSource = [Cost]()
    var pickerView: UIPickerView = UIPickerView()
    
    @IBOutlet weak var recommendedMessageLabel: UILabel!
    @IBOutlet weak var numFeeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recommendedMessageLabel.text = ""
        numFeeTextField.delegate = self
        confirmButton.isEnabled = false
        pickUp(numFeeTextField)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Cargando"
        hud.show(in: self.view)
        
        var url = ApiAccess.endpointRecomendedMessage.replacingOccurrences(of: ApiAccess.mountRplc, with: transaction!.mount!.description)
        url = url.replacingOccurrences(of: ApiAccess.payMethodRplc, with: transaction!.payMethod!.id!)
        url = url.replacingOccurrences(of: ApiAccess.issuerRplc, with: transaction!.bank!.id!)
        ApiAccess.sharedInstance().getRecommendedMessage(url, completionHandler: { (costs, error) in
            hud.dismiss(afterDelay: 1.0)
            
            guard error == nil else {
                //TODO: manejar error
                return
            }
            if let costs = costs {
                self.costDataSource = costs
                self.transaction?.numFees = self.costDataSource.first?.installments
                if let installment = self.costDataSource.first?.installments {
                    self.numFeeTextField.text = installment.description
                    self.recommendedMessageLabel.text = self.costDataSource.first!.recommended_message
                    self.confirmButton.isEnabled = true
                }
                
            }
        })
    }

    //extract from: https://iosdevcenters.blogspot.com/2017/05/uipickerview-example-with-uitoolbar-in.html
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        // cancel y spacebutton tiene como propósito generar el espacio para que el botón OK aparezca
        // a la derecha
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(StepFourFeeViewController.doneClickPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClickPicker(_ sender:UIBarButtonItem, picker pickerView: UIPickerView) {
        numFeeTextField.resignFirstResponder()
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        if let textfield = sender as? UITextField{
            if let text = textfield.text {
                confirmButton.isEnabled = !text.isEmpty
            }
        }
    }
    
    @IBAction func saveTransaction(_ sender: Any) {
        
        if let delegate = delegate {
            delegate.sendTransaction(transaction)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func Save(){
        if let delegate = delegate {
            delegate.sendTransaction(transaction)
            dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - <#UIPickerViewDelegate, UIPickerViewDataSource#>
extension StepFourFeeViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // Numbero de columnas de datos
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de filas de datos
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return costDataSource.count
    }
    
    // El dato a retornar para la fila y componente (columna)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return costDataSource[row].installments?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(!costDataSource.isEmpty){
            transaction?.numFees = costDataSource[row].installments
            self.numFeeTextField.text = costDataSource[row].installments?.description
            self.recommendedMessageLabel.text = costDataSource[row].recommended_message
        }
        
    }
    
}
