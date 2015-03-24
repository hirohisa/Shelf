//
//  View.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

@objc
public protocol ViewDelegate {
    func shelfView(shelfView: Shelf.View, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

@objc
public protocol ViewDataSource {
    func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int
    func shelfView(shelfView: Shelf.View, heightForSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat

    // TODO: enable to set tableview cell or header in section
    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView?
}

public class View: UIView {

    public weak var delegate: ViewDelegate?
    public weak var dataSource: ViewDataSource? {
        didSet {
            reloadData()
        }
    }
    let dataController = DataController()

    let sectionView: SectionView
    required override public init(frame: CGRect) {
        sectionView = SectionView(frame: frame, style: .Plain)

        super.init(frame: frame)
        addSubview(sectionView)

        dataController.view = self
        sectionView.delegate = dataController
        sectionView.dataSource = dataController
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    private var reuseClasses = [String: AnyClass]()
    private var reuseNibs = [String: UINib]()
    private var reuseCells = [String: [UICollectionReusableView]]()
}

extension View {
    func reloadData() {
    }
}

extension View {

    public func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> AnyObject {
        if let result = reuseCells[identifier]?.first {
            return result
        }

        if let result: AnyClass = reuseClasses[identifier] {
            let cellClass = result as UICollectionViewCell.Type
            let cell = cellClass()
            return cell
        }

        return UIView()
    }

    public func registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        if let cellClass: AnyClass = cellClass {
            reuseClasses[identifier] = cellClass
        }
    }
    public func registerNib(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        if let nib = nib {
            reuseNibs[identifier] = nib
        }
    }

}

private let SectionReuseIdentifier = "section"

class SectionViewCell: UITableViewCell {

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.backgroundColor = UIColor.purpleColor()
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        scrollView.frame = contentView.bounds
        scrollView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        contentView.addSubview(scrollView)
    }

}

class SectionView: UITableView {

    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero, style: .Plain)
    }

    func configure() {
        backgroundColor = UIColor.blueColor()
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
        allowsSelection = false
        registerClass(SectionViewCell.self, forCellReuseIdentifier: SectionReuseIdentifier)
    }
}

class DataController: NSObject {
    weak var view: View?
}

class Button: UIButton {
    var indexPath: NSIndexPath?
}

extension DataController {

    func createCell(fromDataSource dataSource: ViewDataSource, indexPath: NSIndexPath) -> UICollectionViewCell {
        // TODO: swizzle or catch notification when did select cell
        let cell = dataSource.shelfView(view!, cellForItemAtIndexPath: indexPath)

        // TODO: will best effort solution
        let tag = 1111
        if cell.contentView.viewWithTag(tag) == nil {
            let button = Button(frame: cell.contentView.bounds)
            button.tag = tag
            button.indexPath = indexPath
            button.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            button.addTarget(self, action: "didSelectCell:", forControlEvents: .TouchUpInside)
            cell.contentView.addSubview(button)
            cell.sendSubviewToBack(button)
        }

        return cell
    }

    func createCells(section: Int) -> [UICollectionViewCell] {

        var cells = [UICollectionViewCell]()
        if let dataSource = view?.dataSource {
            let shelfView = view!
            var x = CGFloat(0)
            for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightForSection: section)
                cell.frame = CGRect(x: x, y: 0, width: width, height: height)

                cells.append(cell)
                x = cell.frame.maxX
            }
        }

        return cells
    }

    func didSelectCell(sender: Button) {
        view?.delegate?.shelfView(view!, didSelectItemAtIndexPath: sender.indexPath!)
    }

}

extension DataController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let dataSource = view?.dataSource {
            return dataSource.shelfView(view!, heightForSection: indexPath.section)
        }

        return 60
    }
}

extension DataController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let dataSource = view?.dataSource {
            return dataSource.numberOfSectionsInShelfView(view!)
        }

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let dataSource = view?.dataSource {
            return dataSource.shelfView(view!, heightForHeaderInSection: section)
        }

        return 0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let dataSource = view?.dataSource {
            return dataSource.shelfView(view!, viewForHeaderInSection: section)
        }

        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionCell = tableView.dequeueReusableCellWithIdentifier(SectionReuseIdentifier, forIndexPath: indexPath) as SectionViewCell

        // TODO: create only visible cells
        let cells = createCells(indexPath.section)

        for cell in cells {
            sectionCell.scrollView.addSubview(cell)
        }

        let width = cells.last?.frame.maxX ?? sectionCell.frame.width
        let contentSize = CGSize(width: width, height: sectionCell.frame.height - 1) // TODO: scrolling will be disabled by using delegate
        sectionCell.scrollView.contentSize = contentSize

        return sectionCell
    }
}