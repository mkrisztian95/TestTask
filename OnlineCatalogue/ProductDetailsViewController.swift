//Test project Kris

import UIKit
import SwiftyJSON

class ProductDetailsViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {
  
  @IBOutlet weak var detailsWebView: UIWebView!
  @IBOutlet weak var carousel: iCarousel!
  @IBOutlet weak var prodThumbnail: UIImageView!
  @IBOutlet weak var prodNumber: UILabel!
  @IBOutlet weak var prodTitle: UILabel!
  @IBOutlet weak var prodPrice: UILabel!
  
  let currentUser = UserDefaults.standard
  
  var imageViewArray:[UIImageView] = []
  var imageUrls:[JSON]! = []
  var details:JSON! = nil
  var productTitle:String = ""
  var productCode:String = ""
  var price:String = ""
  var singleImageUrl:String = ""
  var jsonObject:JSON! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.carousel.delegate = self
    self.carousel.dataSource = self
    
    self.prodPrice.text = self.price
    self.prodTitle.text = self.productTitle
    self.prodNumber.text = self.productCode
    self.prodThumbnail.setUpThumbnailFromUrl(urlString: singleImageUrl)
    
    if currentUser.object(forKey: "lastVisitedString") != nil {
      var array:[String] = currentUser.array(forKey: "lastVisitedString") as! [String]
      if array.index(of: self.productCode) == nil {
        array.append(self.productCode)
      }
      currentUser.set(array, forKey: "lastVisitedString")
    } else {
      var array:[String] = []
      array.append(self.productCode)
      currentUser.set(array, forKey: "lastVisitedString")

    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    APPRequests().fetchItemDetails(itemId: self.productCode).then { json in
      return APPRequests().fetchItemImages(json: json)
      }.then { images in
        self.updateImageSlider(images: images.arrayValue)
    }
    
    APPRequests().fetchItemDescription(itemId: self.productCode).then {json in
      return APPRequests().fetchItemdescriptionText(json: json)
      }.then {text in
        self.updateTextViewForDetails(text: text)
    }
  }
  
  func updateImageSlider(images:[JSON]) {
    self.imageUrls = images
    self.fillCarousel()
  }
  
  func updateTextViewForDetails(text:JSON) {
    self.detailsWebView.loadHTMLString(text.stringValue, baseURL: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func closeView(_ sender: Any) {
    self.dismiss(animated: true) { }
  }
  
  
  public func numberOfItems(in carousel: iCarousel) -> Int {
    return self.imageUrls.count
  }
  
  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    switch option {
    case .spacing:
      return value * 1.1
    case .wrap:
      return 0.0
    default:
      return value
    }
  }
  
  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    return self.imageViewArray[index]
  }
  
  
  func fillCarousel() {
    let height = self.carousel.frame.size.height
    let width = self.carousel.frame.size.height
    let frame = CGRect(x:0, y:-5, width: width, height: height)
    
    for item in self.imageUrls {
      let containerView: UIImageView = UIImageView(frame: frame)
      containerView.setUpThumbnailFromUrl(urlString: item["secure_url"].stringValue)
      containerView.contentMode = .scaleAspectFit
      self.imageViewArray.append(containerView)
    }
    
    self.carousel.reloadData()
  }
}
