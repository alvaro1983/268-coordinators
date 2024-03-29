//
//  RestaurantViewController.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/28/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import CloudKit

protocol RestaurantViewControllerDelegate: AnyObject {
    func addReviewTapped(_ vc: RestaurantViewController)
}

class RestaurantViewController : UITableViewController {
    
    weak var restaurantDelegate: RestaurantViewControllerDelegate?
    
    static func makeFromStoryboard() -> RestaurantViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! RestaurantViewController
    }

    enum Sections : Int {
        case info
        case reviews
        case count
    }
    
    var restaurant: Restaurant?
    var reviews: [Review] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        
        configureUI()
        loadReviews()
    }
    
    private func loadReviews() {
        Restaurants.reviews(for: restaurant!) { (reviews, error) in
            if let e = error {
                print("Error fetching reviews: \(e.localizedDescription)")
            } else {
                self.reviews = reviews
                self.tableView.reloadSections([Sections.reviews.rawValue], with: .none)
            }
        }
    }
    
    @IBAction func addReview(_ sender: UIBarButtonItem) {
        restaurantDelegate?.addReviewTapped(self)
    }
    
    private func configureUI() {
        guard let restaurant = self.restaurant else { return }
        title = restaurant.name
        if let imageURL = restaurant.imageFileURL {
            let data = try! Data(contentsOf: imageURL)
            imageView.image = UIImage(data: data)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurantID = restaurant?.recordID else { return }
        
        if segue.identifier == "photosSegue" {
            let destination = segue.destination as! PhotosViewController
            destination.restaurantID = restaurantID
        }
    }
    
    func insertReview(_ review: Review) {
        reviews.insert(review, at: 0)
        let indexPath = IndexPath(row: 0, section: Sections.reviews.rawValue)
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.info.rawValue {
            return 2
        } else if section == Sections.reviews.rawValue {
            return reviews.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.info.rawValue {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as! AddressCell
                cell.addressLabel.text = restaurant?.address ?? ""
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath)
                return cell
            }
            
        } else {
            let review = reviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.commentLabel.text = review.comment
            cell.authorLabel.text = review.authorName
            cell.ratingView.value = CGFloat(review.stars)
            return cell
        }
    }
}
