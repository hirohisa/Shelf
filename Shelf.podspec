Pod::Spec.new do |s|

  s.name         = "Shelf"
  s.version      = "0.0.3"
  s.summary      = "Shelf can display a view like AppStore for iOS."
  s.description  = <<-DESC
Shelf can display a view like AppStore for iOS. It provides like UITableViewDelegate and UITableViewDatasource about Shelf's protocol. Shelf's base class is comprised of UITableView
                   DESC

  s.homepage     = "https://github.com/hirohisa/Shelf"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com" }

  s.source       = { :git => "https://github.com/hirohisa/Shelf.git", :tag => s.version }

  s.source_files = "Shelf/*.{swift,xib}"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'

end
