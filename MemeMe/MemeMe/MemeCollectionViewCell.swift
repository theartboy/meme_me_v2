//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/6/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    func populateCell(meme: Meme) {
        memeImageView.image = meme.memedImage
        memeImageView.contentMode = .scaleAspectFill
    }

}
