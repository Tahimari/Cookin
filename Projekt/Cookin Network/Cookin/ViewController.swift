//
//  ViewController.swift
//  Cookin
//
//  Created by Kamil Misiak on 12/07/2018.
//  Copyright © 2018 Kamil Misiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var components: [Component] = []
    var filteredComponents: [Component] = []
    var selectedComponents: [Component] = []
    
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        ComponentController.shared.fetchComponentsInfo { (components) in
            if let components = components {
                self.updateUI(with: components)
            }
        }
        
    }
    
    func updateUI(with components: [Component]) {
        DispatchQueue.main.async {
            self.components = components
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let choseDishViewController = segue.destination as! ChoseDishViewController
        choseDishViewController.selectedComponents = selectedComponents
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredComponents.count
        }
        return selectedComponents.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as? DataCell {
            
            var text: String!
            var url: URL!
    
            if inSearchMode {
                text = filteredComponents[indexPath.row].name
                url = filteredComponents[indexPath.row].imgURL
            } else {
                text = selectedComponents[indexPath.row].name
                url = selectedComponents[indexPath.row].imgURL
            }
            cell.congigureCell(text: text, imageURL: url)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        selectedComponents.append(filteredComponents[indexPath.row])
        for component in components{
            if component.name.elementsEqual(filteredComponents[indexPath.row].name) {
                break
            }
            index += 1
        }
        components.remove(at: index)
        filteredComponents.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            components.append(selectedComponents[indexPath.row])
            selectedComponents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            inSearchMode = true
            filteredComponents = components.filter({$0.name.hasPrefix(searchBar.text!)})
            tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        filteredComponents = components
        searchModeOn(true)

        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchModeOn(false)
    }
    
    
    func searchModeOn(_ state: Bool) {
        searchBar.text = ""
        inSearchMode = state
        self.navigationController?.setNavigationBarHidden(state, animated: true)
        self.view.endEditing(!state)
        tableView.setEditing(false, animated: true)
        tableView.allowsSelection = state
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if !inSearchMode {
        let tableViewEdittingMode = tableView.isEditing
        tableView.setEditing(!tableViewEdittingMode, animated: true)
        }
    }
}

