//
//  ItemCell.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 8/8/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class ItemCell: UICollectionViewCell {

    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var mainLabel: UILabel!
    @IBOutlet public weak var subLabel: UILabel!

    public override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 20
    }

}
