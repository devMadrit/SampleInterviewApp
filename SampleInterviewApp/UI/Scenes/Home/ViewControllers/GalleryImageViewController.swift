//
//  GalleryImageViewController.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import UIKit

internal class GalleryImageViewController: BaseViewController {
    
    var viewModel = GalleryImageViewModel()
    var galleryAdapter = GalleryItemsAdapter()
    //MARK: - UIViews
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        setObservers()
        
        viewModel.getGalleryItems()
    }
    
    private func initViews(){
        galleryAdapter.delegate = self
        galleryCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        galleryCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        galleryCollectionView.allowsSelection = true
        galleryCollectionView.delegate = galleryAdapter
        galleryCollectionView.dataSource = galleryAdapter
        reload()
    }
    
    private func setObservers(){
        viewModel.galleryItemsError.addObserver(bound: self, dispatchQueue: .main, autoFire: false) { [weak self] errorMessage in
            self?.showGenericAlertInfo(title: "Error", message: errorMessage ?? "")
        }
        
        viewModel.galleryItems.addObserver(bound: self, dispatchQueue: .main, autoFire: true) { [weak self] (galleryItems) in
            guard let newItems = galleryItems else {
                return
            }
            self?.galleryAdapter.update(newItems: newItems)
        }
        
        viewModel.galleryItemRenamed.addObserver(bound: self, dispatchQueue: .main, autoFire: false) { [weak self] (updatedGalleryImage) in
            guard let self = self, let updatedGalleryImage = updatedGalleryImage else {
                return
            }
            self.galleryAdapter.itemRenamed(updatedItem: updatedGalleryImage, for: self.galleryCollectionView)
        }
        
        viewModel.galleryItemDeleted.addObserver(bound: self, dispatchQueue: .main, autoFire: false) { [weak self] (deletedGalleryImage) in
            guard let self = self, let deletedGalleryImage = deletedGalleryImage else {
                return
            }
            self.galleryAdapter.itemDeleted(deletedItem: deletedGalleryImage, for: self.galleryCollectionView)
        }
    }
}

//MARK: - GalleryItemsAdapterDelegate
extension GalleryImageViewController: GalleryItemsAdapterDelegate {
    
    func onRenameAsked(for item: GalleryImageModel, for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Rename Gallery item", message: "Enter the new name", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Rename", style: .default) {[weak self] (_) in
            //getting the input values from user
            //TODO: Validation *should be* from ViewModel
            let name = alertController.textFields?.first?.text ?? ""
            if name.isEmpty || name.count < 3 {
                alertController.message = "Name should be at least 3 characters long!"
                self?.present(alertController, animated: true, completion: nil)
                return
            }
            self?.viewModel.renameGalleryItem(galleryItem: item, newName: name)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "New name"
            textField.text = item.imageName
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        present(alertController, animated: true, completion: nil)
    }
    
    func onDeleteAsked(for item: GalleryImageModel, for indexPath: IndexPath) {
        self.viewModel.deleteGalleryItem(galleryItem: item)
    }
    
    func reload() {
        galleryCollectionView.reloadData()
    }
}
