//
//  IBGNetworkingManager.swift
//  IBGPostsSwift
//
//  Created by Fady on 6/22/18.
//  Copyright © 2018 instabug. All rights reserved.
//

import UIKit

class IBGNetworkingManager: NSObject {
    
    static let sharedInstance = IBGNetworkingManager()
    
    func getPostsForPage(_ page: Int, success: @escaping (_ postsArray: [Post]) -> Void, failure: @escaping (_ returnError: Error) -> Void) {
        var postsArray = [Post]()
        let urlString = "http://jsonplaceholder.typicode.com/posts"
        
        if let url = urlString.urlForObjectsWithPage(page: page, limit: 10) {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            let ibgSession = URLSession(configuration: configuration)
            
            let task = ibgSession.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    failure(error)
                } else {
                    guard let retrievedData = data else {
                        return
                    }
                    
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: retrievedData) as? [[String : Any]] {
                            for postDictionary in jsonArray {
                                let post = Post()
                                post.title = postDictionary["title"] as? String
                                post.body = postDictionary["body"] as? String
                                postsArray.append(post)
                            }
                            
                            success(postsArray)
                        }
                    } catch { print("Error parsing objects !") }
                }
            }
            
            task.resume()
        }
    }
}
