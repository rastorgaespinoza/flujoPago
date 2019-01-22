//
//  StepTwoPayMethodViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/15/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class StepTwoPayMethodViewController: UIViewController {

    var transaction: Transaction?
    var delegate: TransactionDelegate?

    var pickerView: UIPickerView = UIPickerView()
    var payMethodDataSource = [PayMethod]()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var payMethodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payMethodTextField.delegate = self
        continueButton.isEnabled = false
        transaction?.payMethod = nil
        
        pickUp(payMethodTextField)

        ApiAccess.sharedInstance().getPayMethod(ApiAccess.endpointPayMethods) { (paymethods, error) in
            guard let paymethods = paymethods else {
                //TODO: implementar alguna validacion
                return
            }
            
            self.payMethodDataSource = paymethods.filter { $0.payment_type_id! == "credit_card" }
        }

    }

    //extract from: https://iosdevcenters.blogspot.com/2017/05/uipickerview-example-with-uitoolbar-in.html
    func pickUp(_ textField : UITextField){
        //TextField
        let imageView = UIImageView()
        imageView.image = nil
        textField.leftView = imageView
        textField.leftViewMode = .always
        
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
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(StepTwoPayMethodViewController.doneClickPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClickPicker(_ sender:UIBarButtonItem, picker pickerView: UIPickerView) {
        payMethodTextField.resignFirstResponder()
    }

    @IBAction func toSelectBank(_ sender: Any) {
        performSegue(withIdentifier: "segueStepTwo", sender: nil)
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        if let textfield = sender as? UITextField{
            if let text = textfield.text {
                continueButton.isEnabled = !text.isEmpty
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepThreeBankVC = segue.destination as? StepThreeBankViewController {
            stepThreeBankVC.transaction = self.transaction
            stepThreeBankVC.delegate = self.delegate
        }
    }
}

// MARK: - <#UIPickerViewDelegate, UIPickerViewDataSource#>
extension StepTwoPayMethodViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    // Numbero de columnas de datos
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Número de filas de datos
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payMethodDataSource.count
    }

    // El dato a retornar para la fila y componente (columna)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return payMethodDataSource[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        transaction?.payMethod = payMethodDataSource[row]
        self.payMethodTextField.text = payMethodDataSource[row].name

        self.payMethodTextField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = payMethodDataSource[row].image
        imageView.image = image
        self.payMethodTextField.leftView = imageView
        self.payMethodTextField.leftView?.reloadInputViews()
    }
    
    //extract from: https://stackoverflow.com/questions/27769246/how-can-i-get-images-to-appear-in-ui-pickerview-component-in-swift
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width-30, height: 70))
        
        let myImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 30, height: 30))
        
        
        if let image = self.payMethodDataSource[row].image {
            myImageView.image = image
            
        }else{
            myImageView.image = nil
            
            _ = ApiAccess.sharedInstance().getRequest(payMethodDataSource[row].secure_thumbnail!, completionHandler: { (imageData, errorString) in
                guard let imageData = imageData?.data else {
                    return
                }
                
                DispatchQueue.main.async() {
                    self.payMethodDataSource[row].imageData = imageData
                    pickerView.reloadInputViews()
                }
            })
        }
        
        let rowString = payMethodDataSource[row].name
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }


}
