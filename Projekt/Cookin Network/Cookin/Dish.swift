//
//  dish.swift
//  Cookin
//
//  Created by Kamil Misiak on 12/07/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import Foundation

struct Dish: Decodable {
    let name: String
    let components: [Component]
    let recipe: String
    let imgURL: URL?
}
