//
//  APIManager.swift
//  github-jobs
//
//  Created by Geoff Cornwall on 11/29/17.
//  Copyright © 2017 cornbits. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIManager {
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance;
    }()
    
    func fetchJobs(_ completion: @escaping ([Job]) -> Void) {
        let baseUrl : String = "https://jobs.github.com/positions.json?page="
        var jobsArray: Array<Job> = []
        
        // paginated api calls to fetch more than 50 results
        let jobsGroup = DispatchGroup()
        for page in 1...5 {
            let apiUrl = baseUrl + String(page)
            jobsGroup.enter()
            self.requestJobs(url: apiUrl, completion: { (jobs) in
                jobsArray.append(contentsOf: jobs)
                jobsGroup.leave()
            })
        }

        jobsGroup.notify(queue: DispatchQueue.main, execute: {
            completion(jobsArray)
        })
    }

    func requestJobs(url: String, completion: @escaping ([Job]) -> Void) {
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard let responseJSON = response.result.value else {
                    print("Invalid JSON data received")
                    return
                }

                let json = JSON(responseJSON)
                var jobsArray: Array<Job> = []
                
                json.forEach {(_, jobJson) in
                    let job = Job(json: jobJson)
                    jobsArray.append(job)
                }
                
                completion(jobsArray)
        }
    }
    
}
