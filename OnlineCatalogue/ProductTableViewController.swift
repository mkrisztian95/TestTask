//Test project Kris


import UIKit
import PromiseKit
import SwiftyJSON

class ProductTableViewController: UITableViewController {
  let center = NotificationCenter.default
  var products:[JSON]! = []
  var selectedProduct:JSON! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    center.addObserver(self, selector: #selector(self.refreshTableViewData(_:)), name: NSNotification.Name(rawValue: "refreshTableViewData"), object: nil )
    APPRequests().fetchDataByKeyword().then { json in
      return APPRequests().fetchResults(json: json)
      }.then { results in
        return results.arrayValue
      }.then { resultArray in
        self.reloadTableView(value: resultArray)
    }
  }
  
  func refreshTableViewData(_ notification:Notification) {
    let data = (notification as NSNotification).userInfo as! [String:String]
    
    APPRequests().fetchDataByKeyword(keyWord: data["keyWord"]!).then { json in
      return APPRequests().fetchResults(json: json)
      }.then { results in
        return results.arrayValue
      }.then { resultArray in
        self.reloadTableView(value: resultArray)
    }
  }
  
  
  func reloadTableView(value:[JSON]) {
    self.products = value
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.products.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as! ProductTableViewCell
    let item = products[indexPath.row]
    cell.setUp(price: "\(item["price"].stringValue) \(item["currency_id"].stringValue)", title: item["title"].stringValue, imageUrl: item["thumbnail"].stringValue, json:  item)
    return cell
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetailsView" {
      let cell = sender as! ProductTableViewCell
      self.selectedProduct = cell.jsonObject
      let destinationViewController = segue.destination as! ProductDetailsViewController
      destinationViewController.price = "\(self.selectedProduct["price"].stringValue) \(self.selectedProduct["currency_id"].stringValue)"
      destinationViewController.productTitle = self.selectedProduct["title"].stringValue
      destinationViewController.productCode = self.selectedProduct["id"].stringValue
      destinationViewController.jsonObject = self.selectedProduct
      destinationViewController.singleImageUrl = self.selectedProduct["thumbnail"].stringValue
    }
  }
  
  
}
