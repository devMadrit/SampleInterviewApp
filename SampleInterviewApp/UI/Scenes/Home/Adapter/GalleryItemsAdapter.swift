//
//  GalleryItemsAdapter.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import UIKit

internal protocol GalleryItemsAdapterDelegate: class {
    func reload()
    func onRenameAsked(for item: GalleryImageModel, for indexPath: IndexPath)
    func onDeleteAsked(for item: GalleryImageModel, for indexPath: IndexPath)
}

internal class GalleryItemsAdapter: NSObject {
    
    //MARK: - Constants
    private let _galleryCellIdentifier = "GalleryItemCollectionViewCell"
    
    //MARK: - Data
    var galleryItems = [GalleryImageModel]()
    weak var delegate: GalleryItemsAdapterDelegate?
    
    internal func update(newItems: [GalleryImageModel]){
        self.galleryItems = newItems
        delegate?.reload()
    }
}

extension GalleryItemsAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _galleryCellIdentifier, for: indexPath) as? GalleryItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.loadCell(galleryItem: galleryItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(100), height: CGFloat(120))
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        })
    }
    
    func itemRenamed(updatedItem: GalleryImageModel, for collectionView: UICollectionView) {
        if let indexInDataset = galleryItems.firstIndex(where: { $0.uniqueId == updatedItem.uniqueId }) {
            galleryItems[indexInDataset] = updatedItem
            collectionView.reloadItems(at: [IndexPath(row: indexInDataset, section: 0)])
        }
    }
    
    func itemDeleted(deletedItem: GalleryImageModel, for collectionView: UICollectionView) {
        if let indexInDataset = galleryItems.firstIndex(where: { $0.uniqueId == deletedItem.uniqueId }) {
            galleryItems.remove(at: indexInDataset)
            collectionView.deleteItems(at: [IndexPath(row: indexInDataset, section: 0)])
        }
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        
        let galeryModel = self.galleryItems[indexPath.row]
        let edit = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { [weak self] action in
            self?.delegate?.onRenameAsked(for: galeryModel, for: indexPath)
        }
        
        //delete section
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            self?.delegate?.onDeleteAsked(for: galeryModel, for: indexPath)
        }
        
        return UIMenu(title: "Action", children: [edit, delete])
    }
}
