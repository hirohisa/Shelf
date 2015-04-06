//
//  ViewController.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 4/6/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {

    public var shelfView: Shelf.View = {
        let view = Shelf.View(frame: CGRectZero)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return view
        }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        shelfView.frame = view.bounds
        view.addSubview(shelfView)
    }

}
