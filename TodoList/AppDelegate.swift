 //
//  AppDelegate.swift
//  TodoList
//
//  Created by 松江飛雄馬 on 2015/12/11.
//  Copyright © 2015年 松江飛雄馬. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var now = NSDate()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        //これがないとpermissionエラー
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        // Override point for customization after application launch.
        return true
    }
    // アプリが終了しそうなとき
    func applicationWillResignActive(application: UIApplication) {
       saveNow()
       return
    }
    
    // アプリが終了した時に呼ばれる
    func applicationDidEnterBackground(application: UIApplication) {
        saveNow()
        return
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func saveNow(){
        let myCalendar: NSCalendar = NSCalendar( calendarIdentifier : NSCalendarIdentifierGregorian )!
        let myComponents = myCalendar.components( [ .Year, .Month, .Hour, .Day, .Minute, .Second ],
            fromDate: now ) // myDate、すなわちNSDateから要素として引っ張り出してる
        NSUserDefaults.standardUserDefaults().setObject(myComponents.hour, forKey: "saveMonth")
        NSUserDefaults.standardUserDefaults().setObject(myComponents.day, forKey: "saveDay")
        NSUserDefaults.standardUserDefaults().setObject(myComponents.hour, forKey: "saveHour")
        NSUserDefaults.standardUserDefaults().setObject(myComponents.minute, forKey: "saveMin")
        NSUserDefaults.standardUserDefaults().setObject(myComponents.second, forKey: "saveSec")
        print("セーブ時間　：\( myComponents.day)日\(myComponents.hour)時 \(myComponents.minute)分 \(myComponents.second)秒 )")
        
    }

}

