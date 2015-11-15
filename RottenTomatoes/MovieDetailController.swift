//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Terry Nguyen on 11/11/15.
//  Copyright © 2015 Terry. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {

    @IBOutlet weak var imgPoster: UIImageView!
    
    var movieData:MovieData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let title = movieData?.title {
            self.navigationItem.title = title
        }
        if let urlString = movieData?.poster {
            imgPoster.setImageWithURL(NSURL(string: urlString)!)
            //imgPoster.image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
