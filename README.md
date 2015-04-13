# Shelf

Shelf is a simple dynamic layout like bookshelf for iOS. It provides like UITableViewDelegate and UITableViewDatasource about Shelf's protocol.
Shelf's base class is comprised of `UITableView`


## Features

- [x] Add base logic with DataSource and Delegate.
- [x] Spread cells' layout vertically or horizontally.
- [ ] Be enable to set padding for content.
- [ ] Add content's alignment or create spacing property like `minimumInteritemSpacing`.

## Installation

There are two ways to use this in your project:

- Copy `Shelf` into your project

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

- Use `UICollectionViewCell`

```
shelfView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
```

### Layout

- Set `ContentMode`, it is direction about spreading of cells every section

  ```swift
  enum ContentMode {
      case Horizontal
      case Vertical
  }
  ```

- Set `SectionHeaderPosition`, section header stays anchored or not

  ```swift
  enum SectionHeaderPosition {
      case Floating // header stays anchored
      case Embedding // header scrolls
  }

  ```


### Reload

Reset cells and redisplays visible cells.

```swift
extension View {

    public func reloadData()
}
```

## Example

### ViewController

```swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let shelfView = Shelf.View(frame: frame)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.headerPosition = .Embedding
        shelfView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        return 100
    }

    func shelfView(shelfView: Shelf.View, contentModeForSection section: Int) -> ContentMode {
        return .Vertical
    }

    func shelfView(shelfView: Shelf.View, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func shelfView(shelfView: Shelf.View, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = shelfView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell

        return cell
    }

    func shelfView(shelfView: Shelf.View, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func shelfView(shelfView: Shelf.View, viewForHeaderInSection section: Int) -> UIView? {
        return UILabel()
    }
}
```


## License

Shelf is available under the MIT license.
