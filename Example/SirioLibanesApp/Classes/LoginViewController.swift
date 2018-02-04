//
//  LoginViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mailBox: UITextField!
    @IBOutlet weak var passBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailBox.keyboardType = UIKeyboardType.emailAddress
        mailBox.autocorrectionType = UITextAutocorrectionType.no
        passBox.keyboardType = UIKeyboardType.alphabet
        passBox.isSecureTextEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func mailStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func mailEnded(_ sender: UITextField) {
        
    }
    @IBAction func mailAction(_ sender: Any) {
        passBox.becomeFirstResponder()
    }
    
    @IBAction func passStarted(_ sender: Any) {
        bottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func passAction(_ sender: Any) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        passBox.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        let email = mailBox.text!;
        let pass = passBox.text!;
        
        if (email.isEmpty || pass.isEmpty) {
            displayError()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if (user == nil || error != nil) {
                self.displayError()
                return
            }
            print ("mi user es: " + (user?.displayName ?? "no hay user") )
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            self.displaySuccessfulLogin()
        }
    }
    
    func displayError () {
        let alert = UIAlertController(title: "¡Hubo un error!", message: "Revisa tu mail y contraseña y vuelve a intentarlo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displaySuccessfulLogin () {
        let alert = UIAlertController(title: "¡Ingreso exitoso!", message: "Ya puedes acceder a toda la informacion de tus eventos", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
