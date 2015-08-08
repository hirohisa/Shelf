//
//  ItemCell.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 8/8/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = UIColor.greenColor()
    }

}
