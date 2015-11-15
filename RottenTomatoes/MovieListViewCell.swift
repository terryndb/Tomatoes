//
//  MovieListViewCell.swift
//  RottenTomatoes
//
//  Created by Terry Nguyen on 11/10/15.
//  Copyright © 2015 Terry. All rights reserved.
//

import UIKit

class MovieListViewCell: UITableViewCell {
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var movieData:MovieData? = nil {
        didSet {
            lbName.text = (movieData?.title) ?? ""
            lbDescription.text = (movieData?.description) ?? ""
            if let urlString = (movieData?.poster) {
                imgThumbnail.setImageWithURL(NSURL(string: urlString)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
