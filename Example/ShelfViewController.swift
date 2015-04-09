//
//  ShelfViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 4/6/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Shelf

class ShelfViewController: Shelf.ViewController {

    var show1stSection = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // default is .Floating
        // shelfView.headerPosition = .Floating
        shelfView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let barButtonItem = UIBarButtonItem(title: "toggle", style: .Plain, target: self, action: "toggle")
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func toggle() {
        shelfView.beginUpdates()
        if show1stSection {
            shelfView.deleteContentsInSections([0,1], withRowAnimation: .Automatic)
        } else {
            shelfView.insertContentsInSections([0,1], withRowAnimation: .Automatic)
        }
        show1stSection = !show1stSection
        shelfView.endUpdates()
    }

    // ViewDelegate

    override func shelfView(shelfView: View, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select indexPath section:\(indexPath.section), item:\(indexPath.row)")
    }

    // ViewDataSource

    override func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode {
        return .Vertical
    }

    override func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int {
        return 2
    }

    override func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat {
        return 100
    }

    override func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row%2 {
        case 0:
            return 100
        default:
            return 80
        }
    }


    override func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        if show1stSection {
            return 20
        }
        return 0
    }

    override func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = shelfView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell

        var backgroundColor = UIColor.blackColor()
        var selectedBackgroundColor = UIColor.yellowColor()
        switch indexPath.row%2 {
        case 1:
            backgroundColor = UIColor.grayColor()
        default:
            break
        }

        let selectedBackgroundView = UIView(frame: cell.bounds)

        cell.backgroundColor = backgroundColor
        selectedBackgroundView.backgroundColor = selectedBackgroundColor

        cell.selectedBackgroundView = selectedBackgroundView

        cell.label.text = "item:\(indexPath.row)"

        return cell
    }

    override func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label.text = "section: \(section)"
        label.sizeToFit()
        return label
    }
}