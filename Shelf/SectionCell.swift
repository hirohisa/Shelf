//
//  SectionCell.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 8/8/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.clipsToBounds = false
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        let bundle = NSBundle(forClass: ItemCell.self)
        collectionView.registerNib(UINib(nibName: "ItemCell", bundle: bundle), forCellWithReuseIdentifier: "ItemCell")
    }

}