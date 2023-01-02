//
//  BaseVC.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

class BaseVC: UIViewController {
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.bindDelegates()
        self.setupColors()
        self.setupTexts()
        self.setupFonts()
        self.hideKeyboardWhenTappedAround()
    }
    
//  MARK: - Methods to inherit from Parent Class
    func initialSetup() { }
    func bindDelegates() { }
    func setupColors() { }
    func setupTexts() { }
    func setupFonts() { }
    
}


extension BaseVC {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
