//
//  ComponentController.swift
//  Cookin
//
//  Created by Kamil Misiak on 25/09/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import Foundation
import UIKit

class ComponentController {
    
    static let shared = ComponentController()
    
    let baseURL = URL(string: "http://192.168.64.2/cookin/")!
    
    func fetchComponentsInfo(completion: @escaping ([Component]?) -> Void) {
        
        let componentURL = baseURL.appendingPathComponent("objComponents.json")
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: componentURL) { (data, response, error) in
            if let data = data,
                let components = try? decoder.decode([Component].self, from: data) {
                completion(components)
            } else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
    
    func fetchDishInfo(completion: @escaping ([Dish]?) -> Void) {
        
        let dishURL = baseURL.appendingPathComponent("dishes.json")
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: dishURL) { (data, response, error) in
            if let data = data,
                let dishes = try? decoder.decode([Dish].self, from: data) {
                completion(dishes)
            } else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }
        }
        task.resume()
        
    }
    
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Image error")
                completion(UIImage(named: "Noimage"))
            }
        })
        task.resume()
    }
    
    
}
