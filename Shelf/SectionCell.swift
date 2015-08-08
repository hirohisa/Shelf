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
    @IBOutlet weak var scrollView: UIScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    func configure(cells: [ItemCell]) {

        for cell in cells {
            scrollView.addSubview(cell)
        }

        var width = contentView.frame.width
        if let lastCell = cells.last where lastCell.frame.maxX > width {
            width = lastCell.frame.maxX
        }

        scrollView.contentSize = CGSize(width: width, height: scrollView.frame.height)
    }

}
