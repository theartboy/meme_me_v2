//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/7/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateCell(meme: Meme) {
        self.textLabel?.text = meme.topText
        self.imageView?.image = meme.memedImage
        self.imageView?.contentMode = .scaleAspectFill
    }
    

}
