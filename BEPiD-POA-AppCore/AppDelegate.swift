//
//  AppDelegate.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 9/1/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

//MARK: - Extensions
//MARK: NSDate
extension NSDate{
    func stringDateWithFormat(format:String = "yyyyMMdd-HHmmss") -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let kParseApplicationId = "f1ps0JahKmvDUkMipXzvt18luvtzrBo4fE3s4znj"
    let kParseClientKey = "uFikMMg61aiqg1dIWDtohQbJEZcni5riVOlKnqLJ"
    
    func configureParse(launchOptions: [NSObject: AnyObject]?){
        configureParseRegisterSubclasses()
        Parse.enableLocalDatastore()
        Parse.setApplicationId(kParseApplicationId, clientKey: kParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }
    
    func configureParseRegisterSubclasses(){
        DSPdf.registerSubclass()
        DSTaskAnswer.registerSubclass()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureParse(launchOptions)
        return true
    }

}

