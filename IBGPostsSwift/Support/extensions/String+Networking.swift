//
//  String+Networking.swift
//  IBGPostsSwift
//
//  Created by Fady on 6/22/18.
//  Copyright © 2018 instabug. All rights reserved.
//

import Foundation

extension String {
    func urlForObjectsWithPage(page: Int, limit: Int) -> URL? {
        let urlString = String(format: "%@?_page=%tu&_limit=%tu", self, page, limit)
        return URL(string: urlString)
    }
}
