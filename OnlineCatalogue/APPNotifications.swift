//Test project Kris


import UIKit

class APPNotifications: NSObject {
 let center = NotificationCenter.default
  
  
  func refreshResults(name:String, text:String) {
    let name:String = name
    let userObject = [
      "keyWord": text
    ]
    
    center.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userObject)
  }
  
  func alertPush(_ message:String, type:String) {
    let object:[String:String] = [
      "type": type,
      "message": message
    ]
    
    center.post(name: Notification.Name(rawValue: "alert"), object: nil, userInfo: object)
  }
  
}
