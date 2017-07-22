//
//  ShopViewController.swift
//  PokemonQuiz
//
//  Created by JIAWEI CHEN on 7/18/17.
//  Copyright © 2017 Pokgear Inc. All rights reserved.
//

import UIKit
import StoreKit

class ShopViewController: PQViewController {
    fileprivate var productDictionary = [String: SKProduct]()
    static let buy50CoinsProductId = "com.pokgear.pokemonquiz.50coins"
    static let buy150CoinsProductId = "com.pokgear.pokemonquiz.150coins"
    static let buy500CoinsProductId = "com.pokgear.pokemonquiz.500coins"
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ativityIndicatorView: UIActivityIndicatorView?
    
    @IBOutlet weak var buy50CoinsButton: ResponableButton!
    @IBOutlet weak var buy150CoinsButton: ResponableButton!
    @IBOutlet weak var buy500CoinsButton: ResponableButton!
    @IBOutlet weak var watchAdButton: ResponableButton!
    
    fileprivate var buyButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverPresentationController!.delegate = self

        requestAllProducts()
        buyButtons = [buy50CoinsButton, buy150CoinsButton, buy500CoinsButton, watchAdButton]
        for button in buyButtons {
            button.isHidden = true
        }
        
        Chartboost.setDelegate(self)
    }
    
    @IBAction func buyButtonTouchUp(sender: AnyObject) {
        if sender === self.buy50CoinsButton {
            buyProduct(ofProductId: ShopViewController.buy50CoinsProductId)
        }
        else if sender === self.buy150CoinsButton {
            buyProduct(ofProductId: ShopViewController.buy150CoinsProductId)
        }
        else if sender === self.buy500CoinsButton {
            buyProduct(ofProductId: ShopViewController.buy500CoinsProductId)
        }
        else {
            Chartboost.showRewardedVideo(CBLocationIAPStore)
        }
    }
    
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShopViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.backButton.removeFromSuperview()
    }
}

extension ShopViewController: SKProductsRequestDelegate {
    public func requestAllProducts() {
        let productsRequest = SKProductsRequest(productIdentifiers: [
            ShopViewController.buy50CoinsProductId,
            ShopViewController.buy150CoinsProductId,
            ShopViewController.buy500CoinsProductId
            ])
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    
    public func buyProduct(ofProductId productId: String) {
        if let product = productDictionary[productId] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        for p in products {
            productDictionary[p.productIdentifier] = p
        }
        for button in buyButtons {
            //if button != watchAdButton || Chartboost.hasRewardedVideo(CBLocationIAPStore) {
                button.isHidden = false
            //}
        }
        ativityIndicatorView?.stopAnimating()
        ativityIndicatorView?.removeFromSuperview()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        // do nothing
    }

}

extension ShopViewController: ChartboostDelegate {
    func didCache(inPlay location: String!) {
        if location == CBLocationIAPStore {
            watchAdButton.isHighlighted = false
        }
    }
    
    func didCompleteRewardedVideo(_ location: String!, withReward reward: Int32) {
        if location == CBLocationIAPStore {
            // add store
        }
    }
}
