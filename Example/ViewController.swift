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

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = view.bounds

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.headerPosition = .Embedding
        shelfView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        view.addSubview(shelfView)
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
        return .Vertical
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = shelfView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell

        switch indexPath.row%2 {
        case 0:
            cell.backgroundColor = UIColor.blackColor()
        default:
            cell.backgroundColor = UIColor.grayColor()
        }

        cell.label.text = "item:\(indexPath.row)"

        return cell
    }

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

}

