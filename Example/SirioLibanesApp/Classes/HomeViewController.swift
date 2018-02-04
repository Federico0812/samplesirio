//
//  HomeViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class HomeViewController: UIViewController {
    
    var ref: DatabaseReference!
    var userItemList : [String] = [];
    var allEvents : [AnyHashable : Any] = [:];
    var userEvents : [AnyHashable : Any] = [:];
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 134/255, blue: 244/255, alpha: 1)
        self.navigationItem.setHidesBackButton(true, animated:false);
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserDataAndContinue()
    }
    
    
    func getUserDataAndContinue () {
        let userId = Auth.auth().currentUser?.uid;
        
        if (userId == nil) {
            self.displayError()
            return;
        }
        
        let unwUserId = userId!
        
        ref.child("Users").child(unwUserId).child("eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userEventData = snapshot.value as? [AnyHashable : Any]
            if let unwEventData = userEventData {
                print (unwEventData.description)
                self.userItemList = Array(unwEventData.keys) as! [String];
                self.getEventsDataAndContinue()
            } else {
                self.displayError()
            }
        }) { (error) in
            self.displayError()
        }
    }
    
    func getEventsDataAndContinue () {
        ref.child("Eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventData = snapshot.value as? NSDictionary!
            if let unwEventData = eventData {
                print (unwEventData.description)
                self.allEvents = unwEventData as! [AnyHashable : Any];
                self.filterUserEvents()
            } else {
                self.displayError()
            }
        }) { (error) in
            self.displayError()
        }
    }
    
    func filterUserEvents () {
        var newDictionary = [:] as [AnyHashable : Any]
        for key in self.userItemList {
            newDictionary [key] = self.allEvents [key]
        }
        self.userEvents = newDictionary;
        print(self.userEvents)
        self.updateTableWithCurrentInformation()
    }
    
    func updateTableWithCurrentInformation () {
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro de que desea cerrar su sesión?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "logout", sender: self)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError (message: String = "No pudimos obtener tus eventos, intenta mas tarde.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
