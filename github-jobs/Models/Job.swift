//
//  Job.swift
//  github-jobs
//
//  Created by Geoff Cornwall on 11/29/17.
//  Copyright © 2017 cornbits. All rights reserved.
//

import SwiftyJSON

struct Job {
    
    var id: String!
    var title: String!
    var location: String!
    var type: String!
    var description: String!
    var company: String!
    var url: String!
    var createdAt: Date!

    init(json: JSON) {
        self.id = json["id"].string
        self.title = json["title"].string
        self.location = json["location"].string
        self.type = json["type"].string
        self.description = json["description"].string
        self.company = json["company"].string
        self.url = json["url"].string
        
        let createdAtStr = json["created_at"].string
        let dateForm: DateFormatter = DateFormatter()
        dateForm.dateFormat = "E MMM d HH:mm:ss zzz yyyy"
        self.createdAt = dateForm.date(from: createdAtStr!)
    }

}
