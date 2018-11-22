//
//  dishViewController.swift
//  Cookin
//
//  Created by Kamil Misiak on 13/07/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var dish: Dish?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let dish = dish {
            titleLabel.text = dish.name
            ComponentController.shared.fetchImage(url: dish.imgURL!) { (image) in
                guard let image = image else { self.dishImageView.image = UIImage(named: "Noimage"); return }
                DispatchQueue.main.async {
                    self.dishImageView.image = image
                }
            }
            textView.text = dish.recipe
        }
    }

}
