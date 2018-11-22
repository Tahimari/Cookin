//
//  DataCell.swift
//  Cookin
//
//  Created by Kamil Misiak on 12/07/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func congigureCell(text: String, imageURL: URL) {
        label.text = text
        
        ComponentController.shared.fetchImage(url: imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.cellImageView.image = image
            }
        }
    }
    
}
