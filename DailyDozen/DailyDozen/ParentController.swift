//
//  ContainerViewController.swift
//  DailyDozen
//
//  Created by Will Webb on 9/12/16.
//  Copyright © 2016 NutritionFacts.org. All rights reserved.
//

import UIKit

class ParentController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let leftMenuWidth:CGFloat = 260
    
    override func viewDidLoad() {
        
        // start with slide-out menu closed
        dispatch_async(dispatch_get_main_queue()) {
            
            self.closeMenu(false)
        }
    }
    
    func openMenu() {
        
        print("opening menu")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func closeMenu(animated:Bool = true) {
        
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    func toggleMenu() {
        
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    func closeMenuViaNotification() {
        
        closeMenu()
    }
    
    func rotated() {
        
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                // close menu on rotation-to-landscape
                self.closeMenu()
            }
        }
    }
}
