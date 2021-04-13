Pod::Spec.new do |spec|
  spec.name           = "SPAlbumManager"
  spec.version        = "1.0.0"
  spec.summary        = "A simple camera operation management class."
  spec.homepage       = "https://github.com/swiftprimer/SPAlbumManager"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "swiftprimer@foxmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/swiftprimer/SPAlbumManager.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.swift_version  = "5.0"

end