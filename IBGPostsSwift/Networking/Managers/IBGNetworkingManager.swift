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
    
    func getPostsForPage(_ page: Int, completion: @escaping ([Post]?, Error?) -> ()) {
        let urlString = "http://jsonplaceholder.typicode.com/posts"
        
        guard let url = urlString.urlForObjectsWithPage(page: page, limit: 10) else {
            print("invalid url: \(urlString)")
            return
        }
            
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        
        guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {
            DispatchQueue.main.async { completion(nil, error) }
                    return
        }
                                            
        do {
            let decoder = JSONDecoder()
            
            let birdResult = try decoder.decode([Post].self, from: data)
                DispatchQueue.main.async { completion(birdResult, nil) }
            } catch (let error) {
                 DispatchQueue.main.async { completion(nil, error) }
            }
            
        }
        task.resume()
    }
}
