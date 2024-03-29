//
//  AppCoordinator.swift
//  HelloCloudKit
//
//  Created by ARR on 29/3/24.
//  Copyright © 2024 NSScreencast. All rights reserved.
//

import UIKit

class AppCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let restaurantVC = navigationController.topViewController as! RestaurantsViewController
        restaurantVC.delegate = self
    }
}

extension AppCoordinator: RestaurantsViewControllerDelegate {
    func didSelect(restarurant: Restaurant) {
        let restaurantDetailVC = RestaurantViewController.makeFromStoryboard()
        restaurantDetailVC.restaurantDelegate = self
        restaurantDetailVC.restaurant = restarurant
        navigationController.pushViewController(restaurantDetailVC, animated: true)
    }
}

extension AppCoordinator: RestaurantViewControllerDelegate {
    func addReviewTapped(_ vc: RestaurantViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AddReviewNavigationController") as! UINavigationController
        let reviewCV = nav.topViewController as! ReviewViewController
        reviewCV.addReviewBlock = { [weak self] rVC in
            let review = Review(author: rVC.nameTextField.text ?? "",
                                comment: rVC.commentTextView.text,
                                rating: Float(rVC.ratingView.value),
                                restaurantID: vc.restaurant!.recordID!)
            Restaurants.add(review: review)
            self?.navigationController.dismiss(animated: true, completion: {
                vc.insertReview(review)
            })
        }
        
        navigationController.present(nav, animated: true)
    }
}
