//
//  MainViewController.swift
//  DailyDozen
//
//  Copyright © 2019 Nutritionfacts.org. All rights reserved.
//
// swiftlint:disable function_body_length

import UIKit
import UserNotifications

class MainViewController: UIViewController {
        
    let mainTabBarController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.greenColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false

        // Global App Settings
        setupUnitsType()
        setupReminders()
        setupTabNaviation()
    }
    
    private func setupUnitsType() {
        // ----- Settings: Units Type -----
        if UserDefaults.standard.bool(forKey: SettingsKeys.hasSeenFirstLaunch) == false {
            // Set true to Show UnitsType Toggle to be similar to legacy user's experience
            UserDefaults.standard.set(true, forKey: SettingsKeys.unitsTypeToggleShowPref)
        }
        
        if UserDefaults.standard.object(forKey: SettingsKeys.unitsTypePref) == nil {
            // Skip if user had already set a preferred imperial or metric choice
            // :TBD:ToBeLocalized: set initial default based on device language
            UserDefaults.standard.set(UnitsType.imperial.rawValue, forKey: SettingsKeys.unitsTypePref)
        }
    }
    
    private func setupReminders() {
        // ----- Settings: Reminders -----
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        if UserDefaults.standard.object(forKey: SettingsKeys.reminderCanNotify) == nil {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                UserDefaults.standard.set(settings.authorizationStatus == .authorized, forKey: SettingsKeys.reminderCanNotify)
            }
        }

        if UserDefaults.standard.object(forKey: SettingsKeys.reminderHourPref) == nil {
            UserDefaults.standard.set(8, forKey: SettingsKeys.reminderHourPref)
        }

        if UserDefaults.standard.object(forKey: SettingsKeys.reminderMinutePref) == nil {
            UserDefaults.standard.set(0, forKey: SettingsKeys.reminderMinutePref)
        }

        if UserDefaults.standard.object(forKey: SettingsKeys.reminderSoundPref) == nil {
            UserDefaults.standard.set(true, forKey: SettingsKeys.reminderSoundPref)
        }

        guard UserDefaults.standard.bool(forKey: SettingsKeys.reminderCanNotify) else { return }

        let content = UNMutableNotificationContent()
        content.title = "DailyDozen app." // :NYI:ToBeLocalized:
        content.subtitle = "Do you remember about the app?" // :NYI:ToBeLocalized:
        content.body = "Use this app on a daily basis!" // :NYI:ToBeLocalized:
        content.badge = 1

        if UserDefaults.standard.bool(forKey: SettingsKeys.reminderSoundPref) {
            content.sound = UNNotificationSound.default
        }

        var dateComponents = DateComponents()
        dateComponents.hour = UserDefaults.standard.integer(forKey: SettingsKeys.reminderHourPref)
        dateComponents.minute = UserDefaults.standard.integer(forKey: SettingsKeys.reminderMinutePref)

        let dateTrigget = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "request", content: content, trigger: dateTrigget)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                let logger = LogService.shared
                logger.warning("MainViewController setupReminders() \(error.localizedDescription)")
            }
        }

    }
    
    private func setupTabNaviation() {
        // ----- Tab Navigation Setup -----
        if UserDefaults.standard.bool(forKey: SettingsKeys.hasSeenFirstLaunch) == false {
            UserDefaults.standard.set(true, forKey: SettingsKeys.show21TweaksPref)
        }
        
        mainTabBarController.tabBar.barTintColor = UIColor.white
        mainTabBarController.tabBar.isTranslucent = false
        mainTabBarController.tabBar.tintColor = UIColor.black
        updateTabBarController()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTabBarController(notification:)),
            name: Notification.Name(rawValue: "NoticeUpdatedShowTweaksTab"),
            object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: - Navigation

    @objc func updateTabBarController(notification: Notification) {
        if let index = notification.object as? Int {
            updateTabBarController(selectedIndex: index)
        } else {
            updateTabBarController()
        }
    }

    func updateTabBarController(selectedIndex: Int? = nil) {
        var controllerArray = [UIViewController]()
        
        // Daily Dozen Tab
        let tabDailyDozenStoryboard = UIStoryboard(name: "DozeEntryPagerLayout", bundle: nil)
        guard
            let tabDailyDozenViewController = tabDailyDozenStoryboard
                .instantiateInitialViewController() as? DozeEntryPagerViewController
            else { fatalError("Did not instantiate `DozeEntryPagerViewController`") }

        let titleDoze = NSLocalizedString("navtab.doze", comment: "Daily Dozen (proper noun) navigation tab")
        tabDailyDozenViewController.title = titleDoze
        tabDailyDozenViewController.tabBarItem = UITabBarItem(
            title: titleDoze, // shows below tab bar item icon
            image: UIImage(named: "ic_tabapp_dailydozen"),
            tag: 0
        )
        controllerArray.append(tabDailyDozenViewController)

        // Tweaks Tab
        if UserDefaults.standard.bool(forKey: SettingsKeys.show21TweaksPref) {
            let tab2ndStoryboard = UIStoryboard(name: "TweakEntryPagerLayout", bundle: nil)
            guard
                let tabTweaksViewController = tab2ndStoryboard
                    .instantiateInitialViewController() as? TweakEntryPagerViewController
                else { fatalError("Did not instantiate `TweakEntryPagerViewController`") }

            let titleTweak = NSLocalizedString("navtab.tweaks", comment: "21 Tweaks (proper noun) navigation tab")
            tabTweaksViewController.title = titleTweak
            tabTweaksViewController.tabBarItem = UITabBarItem(
                title: titleTweak,
                image: UIImage(named: "ic_tabapp_21tweaks"),
                tag: 1
            )
            controllerArray.append(tabTweaksViewController)
        }
        
        // More Tab
        let tabInfoStoryboard = UIStoryboard(name: "InfoMenuMainLayout", bundle: nil)
        guard
            let tabInfoViewController = tabInfoStoryboard
                .instantiateInitialViewController() as? InfoMenuMainTableVC
            else { fatalError("Did not instantiate More `InfoMenuMainTableVC`") }

        let titleInfo = NSLocalizedString("navtab.info", comment: "More Information navigation tab")
        tabInfoViewController.title = titleInfo
        tabInfoViewController.tabBarItem = UITabBarItem(
            title: titleInfo,
            image: UIImage(named: "ic_tabapp_more"),
            tag: 0
        )
        controllerArray.append(tabInfoViewController)

        // Settings Tab
        let tabSettingsStoryboard = UIStoryboard(name: "SettingsLayout", bundle: nil)
        guard
            let tabSettingsViewController = tabSettingsStoryboard
                .instantiateInitialViewController() as? SettingsViewController
            else { fatalError("Did not instantiate `SettingsViewController`") }

        let titleSettings = NSLocalizedString("navtab.preferences", comment: "Preferences (aka Settings, Configuration) navigation tab. Choose word different from 'Tweaks' translation")
        tabSettingsViewController.title = titleSettings
        tabSettingsViewController.tabBarItem = UITabBarItem(
            title: titleSettings,
            image: UIImage(named: "ic_tabapp_settings"),
            tag: 0
        )
        controllerArray.append(tabSettingsViewController)

        // Main Nav Bar Controller
        var navControllerArray = [UINavigationController]()
        for vc in controllerArray {
            let navController = UINavigationController(rootViewController: vc)
            navControllerArray.append(navController)
        }
                
        mainTabBarController.viewControllers = navControllerArray
        if let selectedIndex = selectedIndex {
            mainTabBarController.selectedIndex = selectedIndex
        }
        self.view.addSubview(mainTabBarController.view)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension MainViewController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
}
