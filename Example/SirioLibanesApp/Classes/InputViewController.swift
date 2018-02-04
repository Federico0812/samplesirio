//
//  InputViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class InputViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var codeTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    
    @IBAction func inputStarted(_ sender: Any) {
        getManualCode()
    }
    func getManualCode (){
        
        let alertController = UIAlertController(title: "Ingresa el código manualmente", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "De acuerdo", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField?
            if let textfield = firstTextField {
                self.codeTextfield.text = textfield.text
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Código"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func redeem(_ sender: Any) {
        
        let redeemCode = codeTextfield.text!
        
        if (redeemCode.isEmpty) {
            displayError(message: "Debes ingresar el código que aparece en el mail de invitación")
            return
        }
        print (redeemCode)
        
        ref.child("Codigos").child(redeemCode).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventName = snapshot.value as? String!
            if (eventName?.isEmpty ?? true) {
                self.displayError(message: "Ingresaste un código incorrecto")
            } else {
                self.assignKeyToUser(eventName!)
                self.getEventDataAndContinue(eventName!)
            }
        }) { (error) in
            self.displayError(message: "No pudimos agregar tu evento, intenta mas tarde.")
        }
        
    }
    
    func assignKeyToUser (_ key : String)
    {
        let userId = Auth.auth().currentUser?.uid;
        if let unwrappedUserId = userId {
            self.ref.child("Users").child(unwrappedUserId).child("eventos").setValue([key:"true"])
        } else {
            print("something went wrong")
        }
        
    }
    
    func getEventDataAndContinue (_ key :String)
    {
        ref.child("Eventos").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventData = snapshot.value as? NSDictionary!
            if let unwEventData = eventData {
                print (unwEventData.description)
            } else {
                self.displayError(message: "Tuvimos un problema obteniendo la información del evento, buscalo mas tarde en la pantalla principal.")
            }
        }) { (error) in
            self.displayError(message: "No pudimos agregar tu evento, intenta mas tarde.")
        }
    }
    
    
    func displayError (message: String) {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
