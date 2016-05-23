//
//  ViewController.swift
//  bicycle rent
//
//  Created by Nguyen Tran on 5/21/16.
//
import UIKit

class ViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel? = nil
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtUsername.text="crossover@crossover.com"
        txtPassword.text="crossover"
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("accessToken")
        {
            let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
            del.accessToken=token as! String
            loginSuccess()
        }
    }
    
    func showAnAlert(notification:NSNotification){
        var message:UIAlertController
        
        if ("deviceRegistrationFailed" == notification.name) {
            message = UIAlertController(
                  title: "Registration Failure"
                , message: "Push Notifications NOT Enabled"
                , preferredStyle: UIAlertControllerStyle.Alert
            )
        } else {
            message = UIAlertController(
                  title: "Registration Success"
                , message: "Push Notifications Enabled"
                , preferredStyle: UIAlertControllerStyle.Alert
            )

        }
        
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func helloWorldAction(nameTextField: UITextField) {
        nameLabel!.text = "Hello, \(nameTextField.text)"
    }
    
    @IBAction func btnRegisterClicked(sender: UIButton) {
        let username:String? = txtUsername.text
        let password:String? = txtPassword.text
        let service:Services = Services()
        service.register(username!, password: password!)
        {
            (result: String) in
            if(result=="")
            {
                self.showErrorAlert("Register Fail", msg: "Please check your username/password")
            }
            else
            {
                self.loginSuccess()
            }
        }

    }
    @IBAction func btnLoginClicked(sender: UIButton) {
        let username:String? = txtUsername.text
        let password:String? = txtPassword.text
        let service:Services = Services()
        service.login(username!, password: password!)
        {
            (result: String) in
            if(result=="")
            {
                self.showErrorAlert("Login Fail", msg: "Please check your username/password")
            }
            else
            {
                self.loginSuccess()
            }
        }
    }
    func loginSuccess()
    {
        print("loginSuccess")
        loadPlaces()
    }
    func loadPlaces()
    {
        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let service:Services = Services()
        service.getPlaces(del.accessToken)
        {
            (result: AnyObject) in
            print("getPlaceSuccess")
            let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
            del.results=result as! Result
            self.moveToMapView()
        }
    }
    func moveToMapView()
    {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    func showErrorAlert (title:String,msg:String)
    {
        let refreshAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
}

