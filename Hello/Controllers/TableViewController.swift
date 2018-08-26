//
//  TableViewController.swift
//  Hello
//
//  Created by admin on 21/8/2561 BE.
//  Copyright © 2561 admin. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    
    @IBOutlet var tblTask: UITableView!
    
    @IBAction func doEditable(_ sender: Any) {
        self.tblTask.isEditing = true
        self.tblTask.setEditing(true, animated: false)
    }
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    let dailyTasks = ["Check all windows Test \n other string \n Some Text",
                      "Check all doors",
                      "Is the boiler fueled?",
                      "Check the mailbox",
                      "Empty trash containers",
                      "If freezing, check water pipes",
                      "Document \"strange and unusual\" occurrences",]
    
    let weeklyTasks = ["Check inside all cabins",
                       "Flush all lavatories in cabins",
                       "Walk the perimeter of property",]
    
    let monthlyTasks = ["Test security alarm",
                        "Test motion detectors",
                        "Test smoke alarms"]
    
    var products: [Product] = []
    
    static let SERVICEURL = "http://localhost:3000/products"

    func fetchData(url: String){
        Alamofire.request(url, method: .get).responseString(completionHandler: { (response) in
            print(response.value ?? "no value")
        }).responseJSON(completionHandler: { (response) in
            let decoder = JSONDecoder()
            
            do{
                self.products = try decoder.decode([Product].self, from: response.data!)
                self.tblTask.reloadData()
//                print(products[0].productName)
//                print(products[0].comments[0].message)
            }catch{
                print("Error: Can't decode json data")
            }
        })
    }
    
    func doSomethind() throws{
        throw NSError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblTask.estimatedRowHeight = 43
        self.tblTask.rowHeight = UITableViewAutomaticDimension
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .gray
        
        view.addSubview(activityIndicatorView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData(url: TableViewController.SERVICEURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.products.count
        case 1:
            return self.dailyTasks.count
        case 2:
            return self.weeklyTasks.count
        case 3:
            return self.monthlyTasks.count
        default:
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalcell") as! CustomTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.lblTask?.text = self.products[indexPath.row].productName
        case 1:
            cell.lblTask?.text = self.dailyTasks[indexPath.row]
        case 2:
            cell.lblTask?.text = self.weeklyTasks[indexPath.row]
        case 3:
            cell.lblTask?.text = self.monthlyTasks[indexPath.row]
        default:
            cell.lblTask?.text = "No data"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Products"
        case 1:
            return "Daily Tasks"
        case 2:
            return "Weekly Tasks"
        case 3:
            return "Monthly Tasks"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You just selected row \(indexPath.row) on section \(indexPath.section)")
        
        var message = ""
        
        switch indexPath.section {
        case 0:
            message = products[indexPath.row].productName
        case 1:
            message = dailyTasks[indexPath.row]
        case 2:
            message = weeklyTasks[indexPath.row]
        case 3:
            message = monthlyTasks[indexPath.row]
        default:
            message = ""
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        destination.message = message
        self.navigationController?.pushViewController( destination, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0){
            return true
        }else{
            return false
        }
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            activityIndicatorView.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.removeData(rowId: products[indexPath.row].id, handler: { (response) in
                
                self.products.remove(at: indexPath.row)
                
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.activityIndicatorView.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func removeData(rowId: Int, handler: @escaping (DataResponse<Any>) -> Void){
        Alamofire.request("\(TableViewController.SERVICEURL)/\(rowId)" ,method: .delete).responseJSON(completionHandler: handler)
        
        print("\(TableViewController.SERVICEURL)/\(rowId)")

    }
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
