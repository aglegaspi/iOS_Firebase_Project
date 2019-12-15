//
//  ImageHelper.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/13/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    private init() {
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100 // number of objects
        imageCache.totalCostLimit = 10 * 1024 * 1024 // max 10MB used
    }
    static let shared = ImageHelper()
    var imageCache: NSCache<NSString, UIImage>
    
    func getImage(urlStr: String, completionHandler: @escaping (Result<UIImage,AppError>) -> ()) {
        guard let url = URL(string: urlStr) else { completionHandler(.failure(.badURL))
            return
        }
    
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else { completionHandler(.failure(.noDataReceived))
                return }
            guard let data = data else { completionHandler(.failure(.noDataReceived))
                return }
            guard let image = UIImage(data: data) else { completionHandler(.failure(.notAnImage))
                return }
            ImageHelper.shared.imageCache.setObject(image, forKey: urlStr as NSString)
            completionHandler(.success(image))
        } .resume()
    }

    public func image(forKey key: NSString) -> UIImage? { return imageCache.object(forKey: key) }
}
