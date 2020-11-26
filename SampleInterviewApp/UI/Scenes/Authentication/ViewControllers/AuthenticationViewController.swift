//
//  AuthenticationViewController.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import UIKit
import SkyFloatingLabelTextField
import MaterialComponents

internal class AuthenticationViewController: BaseViewController {
    
    //MARK: -Data
    var viewModel = AuthenticationViewModel()
    
    //MARK: - UIViews
    @IBOutlet weak var usernameInput: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordInput: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButtonOutlet: MDCButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loadingIndicator: MDCActivityIndicator!
    
    //MARK: - Outlet Actions
    @IBAction func loginButtonPressed(_ sender: MDCButton) {
        viewModel.authenticate()
    }
    
    @IBAction func onUsernameInputChanged(_ sender: SkyFloatingLabelTextField) {
        viewModel.updateUsername(username: sender.text ?? "")
    }
    
    @IBAction func onPasswordInputChanged(_ sender: SkyFloatingLabelTextField) {
        viewModel.updatePassword(password: sender.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers()
        
        //username is worthless, but lets just add it for estetically purposes
        usernameInput.text = "TestUsername"
        //manual trigger on username
        onUsernameInputChanged(usernameInput)
    }
    
    private func setObservers(){
        viewModel.validationStatus.addObserver(bound: self, autoFire: true) { [weak self] isValid in
            guard let isValid = isValid else {
                return
            }
            
            self?.loginButtonOutlet.isEnabled = isValid
            self?.errorMessage.isHidden = !isValid
            
            if isValid {
                self?.errorMessage.text = ""
                self?.usernameInput.errorMessage = nil
                self?.passwordInput.errorMessage = nil
            }
        }
        
        viewModel.loginStatus.addObserver(bound: self, dispatchQueue: .main, autoFire: true) { [weak self] (status) in
            guard let status = status else {
                return
            }
            self?.onLoginStatus(status: status)
        }
    }
    
    private func onLoginStatus(status: LoginStatus) {
        switch status {
        
        case .idle:
            setInputsEnabled(enabled: true)
            loadingIndicator.stopAnimating()
            errorMessage.text = ""
            viewModel.validateInput()
            
        case .loading:
            setInputsEnabled(enabled: false)
            loadingIndicator.startAnimating()
            errorMessage.text = ""
            
        case .error(let message):
            setInputsEnabled(enabled: true)
            loadingIndicator.stopAnimating()
            errorMessage.text = message
            shakeInputViews()
            usernameInput.errorMessage = usernameInput.placeholder // just to color in red
            passwordInput.errorMessage = passwordInput.placeholder // just to color in red
        
        case .success:
            loadingIndicator.stopAnimating()
            setInputsEnabled(enabled: true)
            goHome()
            
        }
    }
    
    private func setInputsEnabled(enabled: Bool) {
        loginButtonOutlet.isEnabled = enabled
        usernameInput.isEnabled = enabled
        passwordInput.isEnabled = enabled
    }
    
    private func shakeInputViews(){
        usernameInput.performShakeAnimation()
        passwordInput.performShakeAnimation()
        errorMessage.performShakeAnimation()
    }
    
    private func goHome(){
        //TODO more efficent navigation system
        if let galleryImageViewController = GalleryImageViewController.newInstance(from: .home) {
            self.navigationController?.setViewControllers([galleryImageViewController], animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension AuthenticationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameInput {
            passwordInput.becomeFirstResponder()
            viewModel.updateUsername(username: textField.text ?? "")
        } else {
            viewModel.updatePassword(password: textField.text ?? "")
            textField.resignFirstResponder()
        }
        
        return true
    }
}
