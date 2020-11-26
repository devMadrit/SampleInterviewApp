//
//  GalleryImageRepository.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import Foundation

internal class GalleryImageRepository: BaseRepository {
    
    public func getItems(itemsCallback: @escaping RepositoryResponseCallback<[GalleryImageModel]>) {
        // Go To Worker Thread
        DispatchQueue.global(qos: .background).async {
            
            // this is a long operation , so simulate 1 sec delay
            sleep(1)
            
            let itemsResponseData = DummyDataProvider.getGalleyItems()
            do {
                let response = try JSONDecoder().decode(ResultWrapper<[GalleryImageModel]>.self, from: itemsResponseData)
                if response.success {
                    itemsCallback(response.result, nil)
                } else {
                    itemsCallback(nil, ApiError(message: response.error ?? "Generic Error"))
                }
            } catch(let error) {
                itemsCallback(nil, ApiError(error: error))
            }
        }
    }
    
    public func renameGalleryItem(galleryItem: GalleryImageModel, newName: String, updatedItemCallback: @escaping RepositoryResponseCallback<GalleryImageModel>) {
        
        DispatchQueue.global(qos: .background).async {
            
            let renameResponseData = DummyDataProvider.renameGalleryItem(itemUniqueId: galleryItem.uniqueId, newName: newName)
            do {
                let response = try JSONDecoder().decode(ResultWrapper<GalleryImageModel>.self, from: renameResponseData)
                if response.success {
                    updatedItemCallback(response.result, nil)
                } else {
                    updatedItemCallback(nil, ApiError(message: response.error ?? "Generic Error"))
                }
            } catch(let error) {
                updatedItemCallback(nil, ApiError(error: error))
            }
        }
    }
    
    public func delete(galleryItem: GalleryImageModel, deletionItemCallback: @escaping RepositoryResponseCallback<GalleryImageModel>) {
        
        DispatchQueue.global(qos: .background).async {

            let deleteResponseData = DummyDataProvider.delete(itemUniqueId: galleryItem.uniqueId)
            do {
                let response = try JSONDecoder().decode(ResultWrapper<String>.self, from: deleteResponseData)
                if response.success {
                    deletionItemCallback(galleryItem, nil)
                } else {
                    deletionItemCallback(nil, ApiError(message: response.error ?? "Generic Error"))
                }
            } catch(let error) {
                deletionItemCallback(nil, ApiError(error: error))
            }
        }
    }
}

