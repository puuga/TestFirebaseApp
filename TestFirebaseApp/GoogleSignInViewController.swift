//
//  GoogleSignInViewController.swift
//  TestFirebaseApp
//
//  Created by Siwawes Wongcharoen on 7/24/2559 BE.
//  Copyright © 2559 puuga. All rights reserved.
//

import Foundation
import Firebase


class GoogleSignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var lbUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        GIDSignIn.sharedInstance().signInSilently()
        

        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                let user = user
                let name = user!.displayName
                self.lbUserName.text = "Hello \(name)";
//                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.lbUserName.text = "Hello no name"
            }
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
//        GIDSignIn.sharedInstance().signOut()
        try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        if error == nil {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Google SignIn - OK")
            print("userId=\(userId)")
            print("idToken=\(idToken)")
            print("fullName=\(fullName)")
            print("givenName=\(givenName)")
            print("familyName=\(familyName)")
            print("email=\(email)")
            
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                // ...
                if error == nil {
                    print("Firebase SignIn - OK")
                    print("close GoogleSignInViewController")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            print("SignOut")
        }
    }
    
    
}
