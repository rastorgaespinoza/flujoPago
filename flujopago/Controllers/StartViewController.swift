//
//  StartViewController.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/20/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var transaction: Transaction?
    
    @IBOutlet weak var mountValue: UILabel!
    @IBOutlet weak var payMethodValue: UILabel!
    @IBOutlet weak var bankValue: UILabel!
    @IBOutlet weak var feeValue: UILabel!
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var valuesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelsVisibility(false)
        
    }

    @IBAction func popover(){
        self.performSegue(withIdentifier: "FirstSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepOneVC = segue.destination as? UINavigationController {
            if let stepOne = stepOneVC.topViewController as? StepOneMountViewController{
                stepOne.delegate = self
            }
        }
    }
    
    func setLabelsVisibility(_ isVisible: Bool){
        for view in labelStackView.arrangedSubviews{
            if let label = view as? UILabel{
                label.isHidden = !isVisible
            }
        }
        
        for view in valuesStackView.arrangedSubviews{
            if let label = view as? UILabel{
                label.isHidden = !isVisible
            }
        }
    }

}

// MARK: - Delegate para cuando agrego la transacción
extension StartViewController: TransactionDelegate {
    
    func sendTransaction(_ transaction: Transaction?) {
        if let transaction = transaction{
            self.transaction = transaction
            
            mountValue.text = self.transaction!.mount!.description
            payMethodValue.text = self.transaction!.payMethod?.name
            bankValue.text = self.transaction!.bank?.name
            feeValue.text = self.transaction!.numFees!.description
            
            setLabelsVisibility(true)
        }else{
            setLabelsVisibility(false)
        }
    }
}
