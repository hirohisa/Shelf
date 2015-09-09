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

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = view.bounds

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        view.addSubview(shelfView)

        self.shelfView = shelfView
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
        return 5
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func shelfView(shelfView: View, configureItemCell cell: ItemCell, indexPath: NSIndexPath) {
        cell.imageView.backgroundColor = UIColor.greenColor()
        cell.mainLabel.text = "main label"
        cell.subLabel.text = "indexPath [\(indexPath.section), \(indexPath.row)]"
    }

    func shelfView(shelfView: Shelf.View, titleForHeaderInSection section: Int) -> String {
        return "Best New Apps"
    }

    func headerViewsInShelfView(shelfView: View) -> [UIView] {
        let colors = [
            UIColor.redColor(),
            UIColor.blueColor(),
            UIColor.greenColor(),
            UIColor.yellowColor(),
            UIColor.blackColor(),
            UIColor.purpleColor(),
            UIColor.orangeColor(),
            UIColor.grayColor(),
        ]

        return colors.map { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
    }

}

