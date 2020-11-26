//
//  GalleryImageViewModel.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import Foundation

enum RetrieveItemsStatus {
    case success(items: [GalleryImageModel])
    case error(error: String)
}

internal class GalleryImageViewModel {
    
    private var repository: GalleryImageRepository

    // MARK: - Observables
    var galleryItems = MutableLiveData<[GalleryImageModel]>()
    var galleryItemsError = MutableLiveData<String>()
    var galleryItemRenamed = MutableLiveData<GalleryImageModel>()
    var galleryItemDeleted = MutableLiveData<GalleryImageModel>()
    
    init(repository: GalleryImageRepository = GalleryImageRepository()) {
        self.repository = repository
    }
    
    internal func getGalleryItems(){
        repository.getItems { (items, error) in
            if let items = items {
                self.galleryItems.post(items)
            } else if let error = error {
                self.galleryItemsError.post(error.message)
            }
        }
    }
    
    internal func renameGalleryItem(galleryItem: GalleryImageModel, newName: String) {
        repository.renameGalleryItem(galleryItem: galleryItem, newName: newName) { [weak self] (updatedGallery, error) in
            //TODO: Should handle error
            if let updatedGallery = updatedGallery, error == nil {
                self?.galleryItemRenamed.post(updatedGallery)
            }
        }
    }
    
    internal func deleteGalleryItem(galleryItem: GalleryImageModel) {
        repository.delete(galleryItem: galleryItem) { [weak self] (deletedGallery, error) in
            //TODO: Should handle error
            if let deletedGallery = deletedGallery, error == nil {
                self?.galleryItemDeleted.post(deletedGallery)
            }
        }
    }
}
