//Test project Kris


import UIKit
import SwiftyJSON
class FilterTableViewController: UITableViewController {
  
  var categoryArray:[UIButton] = []
  var siteArray:[UIButton] = []
  
  @IBOutlet weak var limitSlider: UISlider!
  @IBOutlet weak var limitLabel: UILabel!
  @IBOutlet weak var categoryScrollView: UIScrollView!
  @IBOutlet weak var siteScrollView: UIScrollView!
  
  
  var selectedCategory:String = ""
  var selectedSite:String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.limitLabel.text = "50"
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    APPRequests().getSiteIdentifiers().then {json in
      return json
      }.then {result in
        self.fillSiteScrollView(json: result)
    }
  }
  
  func fillSiteScrollView(json:JSON) {
    var alredyselectedSite = ""
    var initialy = 10
    if APPRequests().CurrentUser.object(forKey: "selectedSite") != nil {
      initialy = 15
      alredyselectedSite = APPRequests().CurrentUser.string(forKey: "selectedSite")!
    }
    
    for item:JSON in json.arrayValue {
      var y = initialy
      
      if alredyselectedSite == item["site_id"].stringValue {
        y = 5
      }
      
      let button = UIButton(frame: CGRect(x: CGFloat(self.siteArray.count * 60 + 5), y: 10, width: 60.0, height: 20.0))
      button.setTitle(item["site_id"].stringValue, for: .normal)
      button.setTitleColor(.blue, for: .normal)
      button.addTarget(self, action: #selector(self.showCategories(sender:)), for: .touchUpInside)
      self.siteArray.append(button)
      self.siteScrollView.addSubview(button)
    }
    
    self.siteScrollView.contentSize = CGSize(width: CGFloat(60 * self.siteArray.count), height: self.siteScrollView.frame.size.height)
  }
  
  func fillCategoryScrollView(json:JSON) {
    for item:JSON in json.arrayValue {
      let button = UIButton(frame: CGRect(x: CGFloat(self.categoryArray.count * 60 + 5), y: 10, width: 60.0, height: 20.0))
      button.setTitle(item["name"].stringValue, for: .normal)
      button.titleLabel?.adjustsFontSizeToFitWidth = true
      button.setTitleColor(.blue, for: .normal)
      button.layer.setValue(item["id"].stringValue, forKey: "catId")
      button.addTarget(self, action: #selector(self.setCategory(sender:)), for: .touchUpInside)
      self.categoryArray.append(button)
      
      self.categoryScrollView.addSubview(button)
    }
    
    self.categoryScrollView.contentSize = CGSize(width: CGFloat(60 * self.categoryArray.count), height: self.categoryScrollView.frame.size.height)
  }
  
  func showCategories(sender: UIButton) {
    self.clearCategories()
    self.turnOnUIButtonForSiteIds(selectedButton: sender)
    self.categoryScrollView.isHidden = false
    let siteId:String = sender.title(for: .normal)!
    self.selectedSite = siteId
    APPRequests().getSiteTypes(siteIdentifier: siteId).then {json in
      return json
    }.then { result in
      self.fillCategoryScrollView(json: result)
    }
  }
  
  func setCategory(sender:UIButton) {
    self.turnOnUIButtonForCategories(selectedButton: sender)
    self.selectedCategory = sender.layer.value(forKey: "catId") as! String
    
  }
  
  func turnOnUIButtonForSiteIds(selectedButton:UIButton) {
     animate(selectedButton: selectedButton, array: self.siteArray)
  }
  
  
  func turnOnUIButtonForCategories(selectedButton:UIButton) {
    animate(selectedButton: selectedButton, array: self.categoryArray)
  }
  
  func animate(selectedButton:UIButton, array:[UIButton]) {
    for item:UIButton in array {
      var frame = item.frame
      if item == selectedButton {
        frame.origin.y = 5.0
        UIView.animate(withDuration: 0.3, animations: {
          item.frame = frame
        })
      } else {
        frame.origin.y = 15.0
        UIView.animate(withDuration: 0.3, animations: {
          item.frame = frame
        })
      }
    }
  }
  
  func clearCategories() {
    for item in categoryArray {
      item.removeFromSuperview()
    }
    
    categoryArray.removeAll()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func sliderDidChanged(_ sender: Any) {
    self.limitLabel.text = "\(Int(self.limitSlider.value))"
    
  }
  
  
  @IBAction func closeView(_ sender: Any) {
    self.dismiss(animated: true) {
      
    }
  }
  
  @IBAction func applyFilters(_ sender: Any) {
    
    UserDefaults.standard.set(Int(self.limitSlider.value), forKey: "selectedLimit")
    if selectedCategory != "" {
      UserDefaults.standard.set(selectedCategory, forKey: "selectedCategory")
    }
    
    if selectedSite != "" {
      UserDefaults.standard.set(selectedSite, forKey: "selectedSite")
    }
    
    self.dismiss(animated: true) {
      
    }
  }
  
  @IBAction func clearFilters(_ sender: Any) {
    UserDefaults.standard.setValue(nil, forKey: "selectedCategory")
    UserDefaults.standard.setValue(nil, forKey: "selectedLimit")
    UserDefaults.standard.setValue(nil, forKey: "selectedSite")

    self.dismiss(animated: true) {
      
    }
  }
}
