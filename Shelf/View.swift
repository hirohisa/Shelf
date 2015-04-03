//
//  View.swift
//  Shelf
//
//  Created by Hirohisa Kawasaki on 3/14/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol ViewDelegate {
    func shelfView(shelfView: Shelf.View, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

public protocol ViewDataSource {
    func numberOfSectionsInShelfView(shelfView: Shelf.View) -> Int
    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell

    func shelfView(shelfView: Shelf.View, heightFotItemInSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, widthFotItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
    func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat
    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView?
}

public enum ContentMode : Int {
    case Horizontal
    case Vertical
}

public enum SectionHeaderPosition {
    case Floating
    case Embedding
}

public class View: UIView {

    public var headerPosition: SectionHeaderPosition = .Floating {
        didSet {
            reloadData()
        }
    }

    public var delegate: ViewDelegate?
    public var dataSource: ViewDataSource? {
        didSet {
            reloadData()
        }
    }
    let dataController = DataController()

    let tableView: TableView
    required override public init(frame: CGRect) {
        tableView = TableView(frame: frame, style: .Plain)
        super.init(frame: frame)
        configure()
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    private var reuseClasses = [String: AnyClass]()
    private var reuseNibs = [String: UINib]()
    private var reuseCells = [String: [UICollectionReusableView]]()
}

extension View {

    func configure() {
        addSubview(tableView)

        dataController.view = self
        tableView.delegate = dataController
        tableView.dataSource = dataController
    }

    public func reloadData() {
        tableView.reloadData()
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

        fatalError("unable to dequeue a cell with identifier Cell - must register a nib or a class")
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

class SectionView: UITableViewCell {

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
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

class TableView: UITableView {

    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero, style: .Plain)
    }

    func configure() {
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
        allowsSelection = false
        registerClass(SectionView.self, forCellReuseIdentifier: SectionReuseIdentifier)
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

        let cell = dataSource.shelfView(view!, cellForItemAtIndexPath: indexPath)

        // TODO: will change best solution
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

        if let dataSource = view?.dataSource {
            switch dataSource.shelfView(view!, contentModeForSection: section) {
            case .Horizontal:
                return createCells(_horizontal : section)
            case .Vertical:
                return createCells(_vertical : section)
            default:
                break
            }
        }

        return [UICollectionViewCell]()
    }

    func didSelectCell(sender: Button) {
        let cell = sender.superview?.superview

        if let cell = cell as? UICollectionViewCell {
            cell.selected = !cell.selected
        }
        view?.delegate?.shelfView(view!, didSelectItemAtIndexPath: sender.indexPath!)
    }
}

extension DataController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let section = indexPath.section
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Embedding:
                switch indexPath.row {
                case 0:
                    return dataSource.shelfView(view!, heightForHeaderInSection: section)
                default:
                    break
                }
            default:
                break
            }
        }
        return _tableView(tableView, heightForRowAtIndexPath: indexPath)
    }

    func _tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        if let dataSource = view?.dataSource {
            switch dataSource.shelfView(view!, contentModeForSection: section) {
            case .Horizontal:
                return _horizontal(tableView: tableView, section: section)
            case .Vertical:
                return _vertical(tableView: tableView, section: section)
            default:
                break
            }
        }
        return 60
    }
}

extension DataController {

    // TODO: rename all methods

    func _horizontal(#tableView: UITableView, section: Int) -> CGFloat {
        return view!.dataSource!.shelfView(view!, heightFotItemInSection: section)
    }

    func _vertical(#tableView: UITableView, section: Int) -> CGFloat {
        let shelfView = view!
        let dataSource = shelfView.dataSource!

        var length: Int = 0
        var x: CGFloat = 0
        for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
            let indexPath = NSIndexPath(forItem: index, inSection: section)
            let width = dataSource.shelfView(view!, widthFotItemAtIndexPath: indexPath)

            // TODO: Rewrite tableView to shelfView
            if shelfView.frame.width < x + width {
                x = 0
                length += 1
            }
            x += width
        }

        let height = dataSource.shelfView(view!, heightFotItemInSection: section)

        return height * CGFloat(length + 1)
    }


    func createCells(_horizontal section: Int) -> [UICollectionViewCell] {

        var cells = [UICollectionViewCell]()
        if let dataSource = view?.dataSource {
            let shelfView = view!
            var x: CGFloat = 0
            for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)
                cell.frame = CGRect(x: x, y: 0, width: width, height: height)
                x = cell.frame.maxX

                cells.append(cell)
            }
        }

        return cells
    }

    func createCells(_vertical section: Int) -> [UICollectionViewCell] {

        var cells = [UICollectionViewCell]()
        if let dataSource = view?.dataSource {
            let shelfView = view!
            var x: CGFloat = 0
            var length: Int = 0
            for index in 0..<dataSource.shelfView(shelfView, numberOfItemsInSection: section) {
                let indexPath = NSIndexPath(forItem: index, inSection: section)
                let cell = createCell(fromDataSource: dataSource, indexPath: indexPath)
                let width = dataSource.shelfView(shelfView, widthFotItemAtIndexPath: indexPath)
                let height = dataSource.shelfView(shelfView, heightFotItemInSection: section)

                if shelfView.frame.width < x + width {
                    x = 0
                    length += 1
                }

                let y = height * CGFloat(length)

                cell.frame = CGRect(x: x, y: y, width: width, height: height)

                cells.append(cell)
                x = cell.frame.maxX
            }
        }

        return cells
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
        switch view!.headerPosition {
        case .Floating:
            return 1
        case .Embedding:
            return 2
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Floating:
                return dataSource.shelfView(view!, heightForHeaderInSection: section)
            default:
                break
            }
        }

        return 0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let dataSource = view?.dataSource {
            switch view!.headerPosition {
            case .Floating:
                return dataSource.shelfView(view!, viewForHeaderInSection: section)
            default:
                break
            }
        }

        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch view!.headerPosition {
        case .Floating:
            return _tableView(tableView, cellForRowAtIndexPath: indexPath)
        case .Embedding:
            switch indexPath.row {
            case 0:
                return _embedding(tableView, cellForRowAtIndexPath: indexPath)
            default:
                return _tableView(tableView, cellForRowAtIndexPath: indexPath)
            }
        }
    }

    // TODO: Refactor
    func _embedding(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)

        let header = view!.dataSource!.shelfView(view!, viewForHeaderInSection: indexPath.section)
        if let header = header {
            cell.contentView.addSubview(header)
        }

        return cell
    }

    func _tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCellWithIdentifier(SectionReuseIdentifier, forIndexPath: indexPath) as SectionView

        for cell in view.scrollView.subviews {
            cell.removeFromSuperview()
        }

        // TODO: create only visible cells
        let cells = createCells(indexPath.section)

        for cell in cells {
            view.scrollView.addSubview(cell)
        }

        let width = cells.last?.frame.maxX ?? view.frame.width
        let contentSize = CGSize(width: width, height: view.frame.height - 1) // TODO: scrolling will be disabled by using delegate
        view.scrollView.contentSize = contentSize

        return view
    }
}