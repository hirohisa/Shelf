Pod::Spec.new do |s|

  s.name         = "Shelf"
  s.version      = "0.0.1"
  s.summary      = "Shelf is a simple dynamic layout like bookshelf for iOS written in Swift."
  s.description  = <<-DESC
  Shelf is a simple dynamic layout like bookshelf for iOS written in Swift. It provides like UITableViewDelegate and UITableViewDatasource about Shelf's protocol.
                   DESC

  s.homepage     = "https://github.com/hirohisa/Shelf"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com" }

  s.source       = { :git => "https://github.com/hirohisa/Shelf.git", :tag => s.version }

  s.source_files = "Shelf/*.swift"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'

end
