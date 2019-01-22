//
//  StepThreeBankViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/15/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class StepThreeBankViewController: UIViewController {

    var transaction: Transaction?
    var delegate: TransactionDelegate?
    
    var pickerView: UIPickerView = UIPickerView()
    var bankData = [Bank]()
    
    @IBOutlet weak var bankTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        bankTextField.delegate = self
        continueButton.isEnabled = false
        transaction?.bank = nil
        
        pickUp(bankTextField)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Cargando"
        hud.show(in: self.view)
        
        ApiAccess.sharedInstance().getBanks(ApiAccess.endpointBanks + (transaction?.payMethod?.id!)!, completionHandler: { (banks, error) in
            hud.dismiss(afterDelay: 1.0)
            guard error == nil else {
                //TODO: manejar error
                return
            }
            
            if let banks = banks {
                self.bankData = banks
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
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(StepThreeBankViewController.doneClickPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClickPicker(_ sender:UIBarButtonItem, picker pickerView: UIPickerView) {
        bankTextField.resignFirstResponder()
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        if let textfield = sender as? UITextField{
            if let text = textfield.text {
                continueButton.isEnabled = !text.isEmpty
            }
        }
    }
    
    @IBAction func toSelectFee(_ sender: Any) {
        performSegue(withIdentifier: "segueStepThree", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepFourFeeVC = segue.destination as? StepFourFeeViewController {
            stepFourFeeVC.transaction = self.transaction
            stepFourFeeVC.delegate = self.delegate
        }
    }

}

// MARK: - <#UIPickerViewDelegate, UIPickerViewDataSource#>
extension StepThreeBankViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // Numbero de columnas de datos
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de filas de datos
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bankData.count
    }
    
    // El dato a retornar para la fila y componente (columna)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bankData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(!bankData.isEmpty){
            transaction?.bank = bankData[row]
            self.bankTextField.text = bankData[row].name
            self.bankTextField.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let image = bankData[row].image
            imageView.image = image
            self.bankTextField.leftView = imageView
            self.bankTextField.leftView?.reloadInputViews()
        }
    }
    
    //extract from: https://stackoverflow.com/questions/27769246/how-can-i-get-images-to-appear-in-ui-pickerview-component-in-swift
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width-30, height: 70))
        
        let myImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 30, height: 30))

        if let image = self.bankData[row].image {
            myImageView.image = image
            
        }else{
            myImageView.image = nil
            
            _ = ApiAccess.sharedInstance().getRequest(bankData[row].secure_thumbnail!, completionHandler: { (imageData, errorString) in
                guard let imageData = imageData?.data else {
                    return
                }
                
                DispatchQueue.main.async() {
                    self.bankData[row].imageData = imageData
                    pickerView.reloadInputViews()
                }
            })
        }
        
        let rowString = bankData[row].name
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
}
