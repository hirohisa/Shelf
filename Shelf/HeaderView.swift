//
//  HeaderView.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 8/10/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

enum Position {
    case Left
    case Center
    case Right
}

class HeaderView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    var index = 0 {
        didSet {
            updateData()
        }
    }

    var views: [UIView] = [] {
        didSet {
            index = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.backgroundColor = UIColor.redColor()
    }

    func updateData() {
        // if unnecessary views exist, remove them.
        // necessary views exist, change their frame.
        // necessary views dont exist, add subview with frame
    }

    func frameForPosition(position: Position) -> CGRect {
        var frame = scrollView.bounds
        switch position {
        case .Left:
            frame.origin.x = frame.origin.x - frame.width
        case .Right:
            frame.origin.x = frame.origin.x + frame.width
        default:
            break
        }

        return frame
    }
}

extension HeaderView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // TODO: Change index by current view
        // index = next index
    }
}