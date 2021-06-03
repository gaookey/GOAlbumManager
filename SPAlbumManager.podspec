Pod::Spec.new do |spec|
  spec.name           = "SPAlbumManager"
  spec.version        = "1.0.2"
  spec.summary        = "A simple camera operation management class."
  spec.homepage       = "https://github.com/gaookey/SPAlbumManager"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "gaookey@gmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/gaookey/SPAlbumManager.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.swift_version  = "5.0"

end