//

//
//  Created by Molnar Kristian
//  Copyright ©  . All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import SwiftyJSON

class APPUIElements: NSObject {
  
  
  var APPColors: [String: UIColor] = [
    "navigationBar"  : UIColor(red: 31/255.0, green: 131/255.0, blue: 134/255.0, alpha: 1),
    "Info" : UIColor(red: 249/255.0, green: 198/255.0, blue: 108/255.0, alpha: 1),
    "Warning" : UIColor(red: 255/255.0, green: 0/255.0, blue: 64/255.0, alpha: 1),
    "Success1" : UIColor(red: 30/255.0, green: 160/255.0, blue: 73/255.0, alpha: 1),
    "Success" : UIColor(red: 31/255.0, green: 131/255.0, blue: 134/255.0, alpha: 1),
    "Default" : UIColor(red: 61/255.0, green: 130/255.0, blue: 134/255.0, alpha: 1),
    "title": UIColor(red: 246/255.0, green: 201/255.0, blue: 133/255.0, alpha: 1),
    ]
  
  
  func vibrating() {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }
  
  func getCurretnTime()->Int{
    let dt:Date = Date()
    return Int(dt.timeIntervalSince1970)
    
  }
  
  
}





