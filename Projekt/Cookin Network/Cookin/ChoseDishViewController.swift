//
//  ChoseDishViewController.swift
//  Cookin
//
//  Created by Kamil Misiak on 12/07/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import UIKit

class ChoseDishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var chooseDishTabelView: UITableView!
    
    var index = 0
    
    var dishes: [Dish] = []
    var selectedComponents: [Component] = []
    
    var selectedDishes: [Dish] {
        var tempDishes: [Dish] = []
        var counter = 0
        
        for dish in dishes {
            counter = 0
            for component in dish.components {
                for selectedComponent in selectedComponents {
                    if component.name == selectedComponent.name {
                    counter += 1
                    }
                }
            }
            if counter >= dish.components.count{
                tempDishes.append(dish)
            }
        }
        return tempDishes
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseDishTabelView.delegate = self
        chooseDishTabelView.dataSource = self
        
        ComponentController.shared.fetchDishInfo { (dishes) in
            if let dishes = dishes {
                self.updateUI(with: dishes)
            }
        }
    }
    
    func updateUI(with dishes: [Dish]) {
        DispatchQueue.main.async {
            self.dishes = dishes
            self.chooseDishTabelView.reloadData()
            if self.selectedDishes.isEmpty {
                let alert = UIAlertController(title: "Not found any dishes", message: "Plese choose more components", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dishViewController = segue.destination as? DishViewController {
            dishViewController.dish = selectedDishes[index]
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chooseDishTabelView.dequeueReusableCell(withIdentifier: "dishCell", for: indexPath) as! DataCell
            var text: String!
            var url: URL!
            text = selectedDishes[indexPath.row].name
            url = selectedDishes[indexPath.row].imgURL
            cell.congigureCell(text: text, imageURL: url)
            return cell
    }
    
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "dishSegue", sender:nil)
    }
    
}
