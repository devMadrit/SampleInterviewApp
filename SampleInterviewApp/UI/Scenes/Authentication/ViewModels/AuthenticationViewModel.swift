//
//  AuthenticationViewModel.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation

enum LoginStatus {
    case idle
    case success(userModel: UserModel)
    case loading
    case error(errorMessage: String)
}

class AuthenticationViewModel {
    
    //MARK: - Data
    private var _username = ""
    private var _password = ""
    
    private var repository: AuthenticationRepository
    
    //MARK: - Observables
    let loginStatus = MutableLiveData<LoginStatus>(value: .idle)
    let validationStatus = MutableLiveData<Bool>(value: false)
    
    init(repository: AuthenticationRepository = AuthenticationRepository()) {
        self.repository = repository
    }
    
    internal func updateUsername(username: String) {
        self._username = username
        validateInput()
    }
    
    internal func updatePassword(password: String) {
        self._password = password
        validateInput()
    }
    
    public func validateInput(){
        self.validationStatus.post(validate())
    }
    
    private func validate() -> Bool {
        // and a lot of validations, but we will be focusing
        // on simple input empty validations check
        return !_username.isEmpty && !_password.isEmpty
    }
    
    internal func authenticate() {
        
        guard validate() else {
            loginStatus.post(.error(errorMessage: "Check your inputs!"))
            return
        }
        loginStatus.post(.loading)
        repository.authenticate(username: _username, password: _password) { (user, error) in
            if let error = error {
                self.loginStatus.post(.error(errorMessage: error.message))
            } else if let user = user {
                self.loginStatus.post(.success(userModel: user))
            }
        }
    }
}
