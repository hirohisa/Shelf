//
//  HeaderView.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 8/10/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!

    var views: [UIView] = [] {
        didSet {
            updateData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.backgroundColor = UIColor.redColor()
    }

    func updateData() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }

        for view in views {
            //scrollView.addSubview(view)
        }
    }

}
