//
//  DummyDataProvider.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation
internal class DummyDataProvider {
    
    private static let _hardCodedPassword = "password"
    
    static func authenticate(username: String, password: String) -> Data {
        
        guard !username.isEmpty, !password.isEmpty else {
            let result = provideError(with: "Username and Password fields are required!")
            return result.toData()
        }
        
        guard password == DummyDataProvider._hardCodedPassword else {
            let result = provideError(with: "Invalid Credentials")
            return result.toData()
        }
        
        let userResult = [
            "first_name": "Sample Name",
            "last_name": "Sample Surname",
            "username": username,
            "email": "\(username)@example.com"
        ]
        
        return provideSuccess(item: userResult).toData()
    }
    
    static func getGalleyItems() -> Data {
         
        var result = [[String: Any]]()
        
        for i in 0..<15 {
            let uniqueId = UUID().uuidString
            let item = ["unique_id": uniqueId, "image_name": "Image \(i + 1)", "image_url": "https://picsum.photos/200?noCache=\(uniqueId)"]
            result.append(item)
        }
        
        return provideSuccess(item: result).toData()
    }
    
    static func renameGalleryItem(itemUniqueId: String, newName: String) -> Data {
        let result = [
            "unique_id": itemUniqueId,
            "image_name": newName,
            "image_url": "https://picsum.photos/200?noCache=\(itemUniqueId)"
        ]
        return provideSuccess(item: result).toData()
    }
    
    static func delete(itemUniqueId: String) -> Data {
        return provideSuccess(item: "itemUniqueId").toData()
    }
    
    private static func provideError(with message: String) -> [String: Any] {
        let result = ["success": false, "error": message] as [String : Any]
        return result
    }
    
    private static func provideSuccess(item: Any) -> [String: Any]{
        return ["success": true, "result": item]
    }
}

fileprivate extension Dictionary where Key == String, Value == Any {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) // this is unsafe, but just for demostrations purposes, its a best practise to not unforce unwrap
    }
}

fileprivate extension Array where Element == [String: Any] {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) // this is unsafe, but just for demostrations purposes, its a best practise to not unforce unwrap
    }
}
