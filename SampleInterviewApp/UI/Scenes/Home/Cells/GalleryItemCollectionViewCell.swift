//
//  GalleryItemCollectionViewCell.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import UIKit
import Kingfisher

internal class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var galleryImageName: UILabel!
    
    internal func loadCell(galleryItem: GalleryImageModel){
        galleryImageName.text = galleryItem.imageName
        if let imageUrl = URL(string: galleryItem.imageUrl) {
            galleryImage.kf.setImage(with: imageUrl)
        }
    }
}
