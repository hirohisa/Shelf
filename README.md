# Shelf

Shelf can display a view like AppStore for iOS. It provides like UITableViewDelegate and UITableViewDatasource about Shelf's protocol.
Shelf's base class is comprised of `UITableView`

## Features

- [ ] Animation Header View.
- [ ] Enabled to use Pickup Banner like AppStore App.

## Installation

- Install with CocoaPods to write Podfile
```ruby
platform :ios, '8.0'
use_frameworks!

pod 'Shelf', :git => 'https://github.com/hirohisa/Shelf.git'
```

## Usage

### Set Delegate, DataSource

Shelf uses a simple methodology. It defines a delegate and a data source, its client implement.
Shelf.ViewDelegate and Shelf.ViewDataSource are like UITableViewDelegate and UITableViewDatasource.


### Cell

- Use `ItemCell: UICollectionViewCell`

Can't change to custom cell. If you can configure to cell, then you use data source's method `shelfView(shelfView: View, configureItemCell cell: ItemCell, indexPath: NSIndexPath)`.

### Reload

Reset cells and redisplays visible cells.

```swift
extension View {

    public func reloadData()
}
```

## Example

![ ](Example/example.png)

### ViewController

```swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        cell.subLabel.text = "sub label"
    }

    func shelfView(shelfView: Shelf.View, titleForHeaderInSection section: Int) -> String {
        return "Best New Apps"
    }

}
```


## License

Shelf is available under the MIT license.
