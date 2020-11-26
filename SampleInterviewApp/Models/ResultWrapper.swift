//
//  ResultWrapper.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation

internal struct ResultWrapper<T: Codable>: Codable {
    let success: Bool
    var result: T?
    var error: String?
}
