//
//  PaymentController.swift
//  bicycle rent
//
//  Created by Nguyen Tran on 5/21/16.
//

import UIKit
import Caishen
class PaymentController: UIViewController, CardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var buyButton: UIButton?
    @IBOutlet weak var cardNumberTextField: CardTextField!
    @IBOutlet weak var txtName: UITextField!
    var cardInfo: Card!
    var isValidated: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberTextField.cardTextFieldDelegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func buy(sender: AnyObject) {
        if(isValidated == false)
        {
            let refreshAlert = UIAlertController(title: "Validate Fail", message: "Please check your credit card info", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
            return
        }
        sendPayment(txtName.text!)
    }
    func sendPayment(name:String)
    {
        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let service:Services = Services()
        let expire:String = String(format: "%02d:%02d",cardInfo.expiryDate.month,cardInfo.expiryDate.year)
        service.sendPayment(del.accessToken, num: cardInfo.bankCardNumber.rawValue, name: name, code: cardInfo.cardVerificationCode.rawValue, expire:expire)
        {
            (result: Bool) in
            if(result==true)
            {
                print("sendPaymentSuccess")
                self.paymentSucess()
            }
            else
            {
                print("sendPaymentFail")
                self.paymentFail()
            }
            
        }
    }
    func paymentSucess()
    {
        let refreshAlert = UIAlertController(title: "Successful", message: "Thanks for rent", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.navigationController!.popViewControllerAnimated(true)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    func paymentFail()
    {
        let refreshAlert = UIAlertController(title: "Fail", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func cancel(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - CardNumberTextField delegate methods
    
    // This method of `CardNumberTextFieldDelegate` will set the saveButton enabled or disabled, based on whether valid card information has been entered.
    func cardTextField(cardTextField: CardTextField, didEnterCardInformation information: Card, withValidationResult validationResult: CardValidationResult) {
            buyButton?.enabled = validationResult == .Valid
        isValidated = validationResult == .Valid
        if(validationResult == .Valid)
        {
            cardInfo = information
        }
    }
    
    func cardTextFieldShouldShowAccessoryImage(cardTextField: CardTextField) -> UIImage? {
        return UIImage(named: "camera")
    }
    
    func cardTextFieldShouldProvideAccessoryAction(cardTextField: CardTextField) -> (() -> ())? {
        return { [weak self] _ in
            let cardIOViewController = CardIOPaymentViewController(paymentDelegate: self)
            self?.presentViewController(cardIOViewController, animated: true, completion: nil)
        }
    }
    
//     MARK: - Card.io delegate methods
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        cardNumberTextField.prefillCardInformation(cardInfo.cardNumber, month: Int(cardInfo.expiryMonth), year: Int(cardInfo.expiryYear), cvc: cardInfo.cvv)
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}

