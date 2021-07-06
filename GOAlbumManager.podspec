Pod::Spec.new do |spec|
  spec.name           = "GOAlbumManager"
  spec.version        = "1.0.0"
  spec.summary        = "A simple camera operation management class."
  spec.homepage       = "https://github.com/gaookey/GOAlbumManager"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "gaookey@gmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/gaookey/GOAlbumManager.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.swift_version  = "5.0"

end