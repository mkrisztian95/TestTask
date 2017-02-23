//Test project Kris


import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit
import ReachabilitySwift

class APPRequests: NSObject {

  var baseURL:String = "https://api.mercadolibre.com"
  let CurrentUser = UserDefaults.standard
  var category:String = ""
  var limit:Int = 50
  var siteId:String = "MLU"
  
  override init() {
    super.init()
    
    if !(Reachability()?.isReachable)! {
      APPNotifications().alertPush("Check Your Internet Connection", type: "Warning")
    }
    
    if self.CurrentUser.object(forKey: "selectedCategory") != nil {
      self.category = "category=\(self.CurrentUser.string(forKey: "selectedCategory")!)"
    }

    if self.CurrentUser.object(forKey: "selectedLimit") != nil {
      self.limit = self.CurrentUser.integer(forKey: "selectedLimit")
    }

    
    if self.CurrentUser.object(forKey: "selectedSite") != nil {
      self.siteId = self.CurrentUser.string(forKey: "selectedSite")!
    }
  }
  
  //get identifiers of the sites
  func getSiteIdentifiers() -> Promise<JSON> {
    return Promise { fulfill, reject in
      Alamofire.request("\(self.baseURL)/site_domains#json", method: .get).responseJSON().then { json in
        fulfill(JSON(json))
        }.catch { error in
          reject(error)
      }
    }
  }
  
  //get category identifiers
  func getSiteTypes(siteIdentifier:String)  -> Promise<JSON> {
    return Promise { fulfill, reject in
      Alamofire.request("\(self.baseURL)/sites/\(siteIdentifier)/listing_types#json", method: .get).responseJSON().then { json in
        fulfill(JSON(json))
        }.catch { error in
          reject(error)
      }
    }}
  
  // fetching results from call response
  func fetchResults(json: JSON) -> Promise<JSON> {
    return Promise { fulfill, reject in
      if json["results"] != JSON.null {
        fulfill(json["results"])
      } else {
        reject(NSError())
      }
    }
  }
  
  // call to remote API to get products
  func fetchDataByKeyword(keyWord:String = "apple") -> Promise<JSON> {
    return Promise { fulfill, reject in
      Alamofire.request("\(self.baseURL)/sites/\(self.siteId)/search?\(self.category)&limit=\(self.limit)&q=\(keyWord)#json", method: .get).responseJSON().then { json in
          fulfill(JSON(json))
        }.catch { error in
          reject(error)
      }
    }
  }
  
  //call to remote API to fetch single product details
  func fetchItemDetails(itemId:String) -> Promise<JSON> {
    return Promise { fulfill, reject in
      Alamofire.request("\(self.baseURL)/items/\(itemId)#json", method: .get).responseJSON().then { json in
        fulfill(JSON(json))
        }.catch { error in
          reject(error)
      }
    }
  }
  
  // fetching item images from single product
  func fetchItemImages(json: JSON) -> Promise<JSON> {
    return Promise { fulfill, reject in
      if json["pictures"] != JSON.null {
        fulfill(json["pictures"])
      } else {
        reject(NSError())
      }
    }
  }
  
  // fetching item description from single product
  func fetchItemDescription(itemId:String) -> Promise<JSON> {
    return Promise { fulfill, reject in
      Alamofire.request("\(self.baseURL)/items/\(itemId)/description#json", method: .get).responseJSON().then { json in
        fulfill(JSON(json))
        }.catch { error in
          reject(error)
      }
    }
  }
  
  // fetching item description text from single product
  func fetchItemdescriptionText(json: JSON) -> Promise<JSON> {
    return Promise { fulfill, reject in
      if json["text"] != JSON.null {
        fulfill(json["text"])
      } else {
        reject(NSError())
      }
    }
  }
  
  
  
  
  
  
  
}
