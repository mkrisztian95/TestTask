//Test project Kris


import UIKit
import Kingfisher
import SwiftyJSON

class APPImageCache: NSObject {

}

extension UIImageView {
  func setUpThumbnailFromUrl(urlString:String) {
    let url = URL(string: urlString)
    
    var cachename = urlString
    if cachename == "" {
      cachename = "default"
    }
    let myCache = ImageCache(name: cachename)
    
    
    
    self.kf.setImage(with: url, placeholder:  #imageLiteral(resourceName: "NoImage"), options: [.targetCache(myCache)], progressBlock: { (receivedSize, totalSize) in
      
    }) { (image, error, cacheType, imageUrl) in
      
    }
  }
}
