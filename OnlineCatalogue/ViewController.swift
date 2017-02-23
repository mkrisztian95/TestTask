//Test project Kris


import UIKit
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var filtersContainer: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var carousel: iCarousel!
  
  var itemsCount:Int = 0
  var recentItemViewArray:[UIView] = []
  
  public func numberOfItems(in carousel: iCarousel) -> Int {
    return self.recentItemViewArray.count
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
    return self.recentItemViewArray[index]
  }
  
  func clearCarousel() {
    for item in self.recentItemViewArray {
      item.removeFromSuperview()
    }
    self.recentItemViewArray.removeAll()
  }
  
  func fillCarousel() {
    self.clearCarousel()
    let height = self.carousel.frame.size.height
    let width = self.carousel.frame.size.height
    let frame = CGRect(x:0, y:-5, width: width, height: height)
    
    if APPRequests().CurrentUser.object(forKey: "lastVisitedString") == nil { return }
    
    let array:[String] = APPRequests().CurrentUser.array(forKey: "lastVisitedString") as! [String]
    
    for i:Int in 0...array.count - 1 {
      let containerView: LastVisitedItem = LastVisitedItem(frame: frame)
      containerView.setUp(itemId: array[array.count - i - 1])
      self.recentItemViewArray.append(containerView)
      
      if i == 4 {
        self.carousel.reloadData()
        return
      }
    }
    
    self.carousel.reloadData()
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.alert(_:)), name: NSNotification.Name(rawValue: "alert"), object: nil)
    
        // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewDidAppear(_ animated: Bool) {
    self.fillCarousel()
    self.filtersContainer.text = "#\(APPRequests().siteId) #\(APPRequests().category)"
    self.carousel.delegate = self
    self.carousel.dataSource = self
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    APPNotifications().refreshResults(name: "refreshTableViewData", text: textField.text!.replacingOccurrences(of: " ", with: "%20"))
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if self.searchTextField.text == "" {
      APPNotifications().refreshResults(name: "refreshTableViewData", text: "apple")
    } else {
      APPNotifications().refreshResults(name: "refreshTableViewData", text: textField.text!.replacingOccurrences(of: " ", with: "%20"))
    }
    textField.resignFirstResponder()
  }
  
  @IBAction func endEditingForce(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  @IBAction func search(_ sender: Any) {
    if self.searchTextField.text == "" {
      
    }
    self.view.endEditing(true)
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func alert(_ notif:Notification) {
    let object = (notif as NSNotification).userInfo as! [String:String]
    var type:APPBanners.APPBannerTypes! = nil
    let remoteType:String = object["type"]!
    switch remoteType {
    case "Warning":
      type = .Warning
      break
    case "Success":
      type = .Success
      break
    default:
      type = .Default
    }
    
    let message = object["message"]
    self.alertWithMessage(message!, type:type)
  }
  
  func alertWithMessage(_ message:String, type:APPBanners.APPBannerTypes) {
    let banner = APPBanners(withTarget: (self.navigationController?.view)!, andType: type)
    banner.showBannerForViewControllerAnimated(true, message: message)
  }
  
}

