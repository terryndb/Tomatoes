//
//  MovieData.swift
//  RottenTomatoes
//
//  Created by Terry Nguyen on 11/12/15.
//  Copyright © 2015 Terry. All rights reserved.
//

import Foundation

class MovieData {
    var title = ""
    var description = ""
    var year = 2015
    var mpaaRating = "PG-13"
    var runtime = 100
    var criticsScore = 100
    var audienceScore = 100
    var thumbnail = ""
    var poster = ""
    
    func parseFromJSON(json:NSDictionary) {
        title = json["title"] as! String
        description = json["synopsis"] as! String
        year = json["year"] as! Int
        mpaaRating = json["mpaa_rating"] as! String
        runtime = json["runtime"] as! Int
        criticsScore = json.valueForKeyPath("ratings.critics_score") as! Int
        audienceScore = json.valueForKeyPath("ratings.audience_score") as! Int
        thumbnail = (json.valueForKeyPath("posters.thumbnail") as! String).stringByReplacingOccurrencesOfString("http://", withString: "https://")
        poster = (json.valueForKeyPath("posters.detailed") as! String).stringByReplacingOccurrencesOfString("http://", withString: "https://")
    }
}