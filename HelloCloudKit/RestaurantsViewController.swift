//
//  RestaurantsViewController.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/13/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

protocol RestaurantsViewControllerDelegate: AnyObject {
    func didSelect(restarurant: Restaurant)
}

class RestaurantsViewController : UITableViewController {
    static func makeFromStoryboard() -> RestaurantsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! RestaurantsViewController
    }

    weak var delegate: RestaurantsViewControllerDelegate?
    
    var restaurants: [Restaurant] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadRestaurants()
    }
    
    func loadRestaurants() {
        Restaurants.all { (restaurants, error) in
            if let e = error {
                print("Error fetching restaurants: \(e)")
            } else {
                self.restaurants = restaurants
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurantSegue", let indexPath = tableView.indexPathForSelectedRow {
            let destination = segue.destination as! RestaurantViewController
            let restaurant = restaurants[indexPath.row]
            destination.restaurant = restaurant
        }
    }
    
    // MARK - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        
        if let imageURL = restaurant.imageFileURL {
            if let data = try? Data(contentsOf: imageURL) {
                cell.imageView?.image = UIImage(data: data)
                cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                cell.imageView?.clipsToBounds = true
            }
        } else {
            cell.imageView?.image = nil
        }
        
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.address
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        delegate?.didSelect(restarurant: restaurant)
    }
}
