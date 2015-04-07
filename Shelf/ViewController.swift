//
//  ViewController.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/6/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class ViewController: UIViewController, ViewDelegate, ViewDataSource {

    public var shelfView: View = {
        let view = Shelf.View(frame: CGRectZero)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return view
        }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        shelfView.frame = view.bounds
        shelfView.delegate = self
        shelfView.dataSource = self
        view.addSubview(shelfView)
    }

    // ViewDelegate

    public func shelfView(shelfView: View, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }

    // ViewDataSource

    public func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int {
        return 1
    }

    public func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat {
        return 60
    }

    public func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return shelfView.frame.width
    }

    public func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode {
        return .Horizontal
    }

    public func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    public func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    public func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}