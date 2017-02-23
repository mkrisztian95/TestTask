//Test project Kris


import UIKit
import SwiftyJSON
class ProductTableViewCell: UITableViewCell {
  
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  //general json object
  var jsonObject:JSON! = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //Setting up the ui of the view file
  func setUp(price:String, title:String, imageUrl:String, json:JSON){
    self.titleLabel.adjustsFontSizeToFitWidth = true
    self.priceLabel.text = price
    self.titleLabel.text = title
    self.thumbnailView.setUpThumbnailFromUrl(urlString: imageUrl)
    self.jsonObject = json
  }
  
}
