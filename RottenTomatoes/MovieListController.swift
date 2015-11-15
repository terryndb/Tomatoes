//
//  MovieListController.swift
//  RottenTomatoes
//
//  Created by Terry Nguyen on 11/10/15.
//  Copyright © 2015 Terry. All rights reserved.
//

import UIKit
import AFNetworking

class MovieListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var popupNetworkError: UIView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesData = [MovieData]()
    var filteredMoviesData = [MovieData]()
    var refreshControl:UIRefreshControl! = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.delegate = self;
        tableView.dataSource = self;
        refreshControl.addTarget(self, action: "requestData", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        searchBar.delegate = self
        self.navigationItem.title = "Movies"
        indicatorLoading.transform = CGAffineTransformMakeScale(2, 2)
        
        requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredMoviesData.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieListCell", forIndexPath: indexPath) as! MovieListViewCell
        let movieData = filteredMoviesData[indexPath.row]
        cell.movieData = movieData
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            filteredMoviesData = moviesData
        } else {
            filteredMoviesData = moviesData.filter { (movieData) -> Bool in
                return movieData.title.lowercaseString.containsString(searchBar.text!.lowercaseString)
            }
        }
        tableView.reloadData()
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! MovieListViewCell
        let controller = segue.destinationViewController as! MovieDetailController
        controller.movieData = cell.movieData
    }

    
    func requestData() {
        let dataURL = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214"
        let url = NSURL(string: dataURL)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if(error == nil) {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let moviesJson = json["movies"] as! [NSDictionary]
                for(var i = 0; i < moviesJson.count; ++i) {
                    let movieData = MovieData()
                    movieData.parseFromJSON(moviesJson[i])
                    self.moviesData.append(movieData)
                    self.filteredMoviesData = self.moviesData
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.indicatorLoading.stopAnimating()
                    self.refreshControl.endRefreshing()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showErrorPopup()
                    self.indicatorLoading.stopAnimating()
                })
            }
        }
        task.resume()
    }
    
    func showErrorPopup() {
        UIView.animateWithDuration(0.5) { () -> Void in
            var frame = self.popupNetworkError.frame;
            frame.offsetInPlace(dx: 0, dy: frame.height)
            self.popupNetworkError.frame = frame
        }
    }
}
