//
//  SearchViewController.swift
//  MyMovList
//
//  Created by BigMac on 1/4/15.
//  Copyright (c) 2015 TrustApp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, APIControllerProtocol {
    var tableData = []
    var api = APIController()
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sbSearch.showsScopeBar = true
        sbSearch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell

        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let cellText: String? = rowData["name"] as? String
        cell.textLabel?.text = cellText
        cell.imageView?.image = UIImage(named: "Blank52")
        
        // Get the formatted price string for display in the subtitle
        //let formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        //let urlString: NSString = rowData["urlPoster"] as NSString
        let urlString: NSString = "http://static.giantbomb.com/uploads/scale_avatar/8/87790/2491510-box_kz.png"

        var image = self.imageCache[urlString]
        
        if (image == nil){
            var imgURL: NSURL! = NSURL(string: urlString)
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil{
                    image = UIImage (data: data)
                    
                    self.imageCache[urlString] = image
                }
                else{
                    println("Error: \(error.localizedDescription)")
                }
            })
        }

        dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                    cellToUpdate.imageView?.image = image
            }
            })

        //cell.detailTextLabel?.text = formattedPrice
        cell.detailTextLabel?.text = "TESTE"

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name: String = rowData["name"] as String
        
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = "teste"
        alert.addButtonWithTitle("OK")
        alert.show()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        api.searchForMovie(sbSearch.text)
        api.delegate = self
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.SearchTableView!.reloadData()
        })
    }

    @IBOutlet weak var SearchTableView: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
}

