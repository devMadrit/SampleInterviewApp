//
//  BaseRepository.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation

typealias RepositoryResponseCallback<T: Resource> = (_ result: T?, _ error: ApiError?) -> Void

struct ApiError: Error {
    var message: String
    
    init(error: Error) {
        self.message = error.localizedDescription
    }
    
    init(message: String) {
        self.message = message
    }
}

internal class BaseRepository {
    
}

extension Array: Resource where Element: Resource {}
