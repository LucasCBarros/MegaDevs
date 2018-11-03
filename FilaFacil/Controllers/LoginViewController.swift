//
//  LoginViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class LoginViewController: MyViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Properties
    let authService = AuthService()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.textColor = UIColor.white
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTxtField.textColor = UIColor.white
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        usernameTxtField.textColor = UIColor.white
        usernameTxtField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        registerBtn.clipsToBounds = true
        registerBtn.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        authService.checkUserLogged { (authenticated) in
            if authenticated {
                DispatchQueue.main.async {
                    self.presentLoggedInScreen()
                }
            } else {
                DispatchQueue.main.async {
                    self.authService.signOut()
                }
            }
        }
    }
    
    // Creates a new Account in FB
    @IBAction func click_createAccount(_ sender: Any) {
        createAccount()
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createAccount() {
        /// Check empty fields
        if (usernameTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Name field can't be empty")
        }
        if (emailTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Email field can't be empty!")
        }
        if (passwordTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Password field can't be empty")
        }
        
        guard emailTxtField.text != nil else {
            print("Email Error!")
            return
        }
        guard passwordTxtField.text != nil else {
            print("Password Error!")
            return
        }
        guard usernameTxtField.text != nil else {
            print("Name Error!")
            return
        }
    }
    
    // Alert message case error
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // Opens app screens to loggedIn users
    func presentLoggedInScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TabBarView", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate?
        appDelegate??.window?.rootViewController = tabBarController
    }
}
