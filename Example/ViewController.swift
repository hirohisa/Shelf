//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Shelf

class CollectionViewCell: UICollectionViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = bounds
        contentView.addSubview(label)
    }
}

class ViewController: UIViewController {

    var shelfView: Shelf.View?
    var show1stSection = true
    var headerPosition = SectionHeaderPosition.Floating

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = view.bounds

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.headerPosition = headerPosition
        shelfView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        shelfView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(shelfView)

        self.shelfView = shelfView

        let barButtonItem = UIBarButtonItem(title: "toggle", style: .Plain, target: self, action: "toggle")
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func toggle() {
        if let shelfView = shelfView {
            shelfView.beginUpdates()
            if show1stSection {
                shelfView.deleteContentsInSections([0,1], withRowAnimation: .Automatic)
            } else {
                shelfView.insertContentsInSections([0,1], withRowAnimation: .Automatic)
            }
            show1stSection = !show1stSection
            shelfView.endUpdates()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: Shelf.ViewDelegate {

    func shelfView(shelfView: View, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select indexPath section:\(indexPath.section), item:\(indexPath.row)")
    }
}

extension ViewController: Shelf.ViewDataSource {

    func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int {
        return 2
    }

    func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat {
        return 100
    }

    func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row%2 {
        case 0:
            return 100
        default:
            return 80
        }
    }

    func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode {
        switch section {
        case 0:
            return .Vertical
        default:
            return .Horizontal
        }
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        if show1stSection {
            return 20
        }
        return 0
    }

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label.text = "section: \(section)"
        label.sizeToFit()
        return label
    }

}

