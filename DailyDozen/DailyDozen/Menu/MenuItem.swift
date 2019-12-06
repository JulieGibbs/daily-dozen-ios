//
//  MenuItem.swift
//  DailyDozen
//
//  Created by Konstantin Khokhlov on 31.01.2018.
//  Copyright © 2018 Nutritionfacts.org. All rights reserved.
//

import UIKit

enum MenuItem: Int {

    // MARK: - Nested
    
    /// Links: provides url path component "https://nutritionfacts.org/COMPONENT/"
    /// :NYI:ToBeLocalized: web link components
    /// EN: "https://nutritionfacts.org/donate/"
    /// ES: "https://nutritionfacts.org/es/dona-a-nutritionfacts-org/"
    private struct Links {
        static let videos = "videos"
        static let book = "book" // "How Not to Die"
        static let cookbook = "cookbook" // "The How Not to Die Cookbook"
        static let diet = "how-not-to-diet" // "How Not to Diet"
        static let challenge = "daily-dozen-challenge" // "Daily Dozen Challenge"
        static let donate = "donate"
        static let subscribe = "subscribe"
        static let source = "open-source"
    }

    /// Defines item order for `MenuTableViewController`
    case dailyServings, dailyTweaks, videos, book, cookbook, diet, challenge, donate, subscribe, source, settings, backup, about, develop

    var link: String? {
        switch self {
        case .dailyServings, .dailyTweaks, .settings, .backup, .about, .develop:
            return nil // not a URL link
        case .videos:
            return Links.videos
        case .book:
            return Links.book
        case .cookbook:
            return Links.cookbook
        case .diet:
            return Links.diet
        case .challenge:
            return Links.challenge
        case .donate:
            return Links.donate
        case .subscribe:
            return Links.subscribe
        case .source:
            return Links.source
        }
    }

    var controller: UIViewController? {
        switch self {
        case .dailyServings:
            return ServingsPagerBuilder.instantiateController()
        case .dailyTweaks:
            return TweaksPagerBuilder.instantiateController()
        case .about:
            return AboutBuilder.instantiateController()
        case .settings:
            return SettingsBuilder.instantiateController()
        case .develop:
            return DevelopBuilder.instantiateController()
        case .videos, .book, .cookbook, .diet, .challenge, .donate, .subscribe, .source, .backup:
            return nil // not a View Controller
        }
    }
}
