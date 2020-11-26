//
//  AuthenticationRepository.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation

internal class AuthenticationRepository: BaseRepository {
    
    public func authenticate(username: String, password: String, callback: @escaping RepositoryResponseCallback<UserModel>) {
        
        // Go To Worker Thread
        DispatchQueue.global(qos: .background).async {
            
            // this is a long operation , so simulate 1 sec delay
            sleep(1)
            
            let authResponseData = DummyDataProvider.authenticate(username: username, password: password)
            do {
                let response = try JSONDecoder().decode(ResultWrapper<UserModel>.self, from: authResponseData)
                if response.success {
                    callback(response.result, nil)
                } else {
                    callback(nil, ApiError(message: response.error ?? "Generic Error"))
                }
            } catch(let error) {
                callback(nil, ApiError(error: error))
            }
        }
    }
}
