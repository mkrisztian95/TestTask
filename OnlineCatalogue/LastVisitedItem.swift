//Test project Kris


import UIKit
import SwiftyJSON

@IBDesignable class LastVisitedItem: UIView {
  
  var view: UIView!
  
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  func xibSetup() {
    view                  = loadViewFromNib()
    // use bounds not frame or it'll be offset
    view.frame            = bounds
    // Make the view stretch with containing view
    view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    // Adding custom subview on top of our view (over any custom drawing > see note below)
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib    = UINib(nibName: "LastVisitedItem", bundle: bundle)
    let view   = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
  
  override init(frame: CGRect) {
    // 1. setup any properties here
    // 2. call super.init(frame:)
    super.init(frame: frame)
    // 3. Setup view from .xib file
    xibSetup()
    
  }
  
  
  func setUp(itemId:String){
    APPRequests().fetchItemDetails(itemId: itemId).then { json in
      self.updateUIonCart(json: json)
    }
  }
  
  func updateUIonCart(json:JSON) {
    self.avatar.setUpThumbnailFromUrl(urlString: json["thumbnail"].stringValue)
    self.priceLabel.text = "\(json["price"].stringValue) \(json["currency_id"].stringValue)"
    self.titleLabel.text = json["title"].stringValue
    
    self.titleLabel.adjustsFontSizeToFitWidth = true
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  
  
  
}
