//
//  ViewController.swift
//  LocalNotificationSwift3


import UIKit
import UserNotifications
import NotificationCenter
import UserNotificationsUI

class ViewController: UIViewController {
var isGrantedNotificationAccess:Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let requestIdentifier = "SampleRequest"
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        }
        )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func send10SecNotification(_ sender: UIButton) {
        if isGrantedNotificationAccess{
            let content = UNMutableNotificationContent()
            content.title = "Local Notification Swift3"
            content.subtitle = "Nice Examples"
            content.body = "Notification after 5 seconds"
            content.sound = UNNotificationSound.default()
            content.launchImageName = "monkey.png"
            
//            content.badge = 5
            
           // title: String containing the primary reason for the alert.
           // subtitle: String containing an alert subtitle (if required)
           // body: String containing the alert message text
           // badge: Number to show on the app’s icon.
           // sound: A sound to play when the alert is delivered. Use UNNotificationSound.default() or create a custom sound from a file.
            //launchImageName: name of a launch image to use if your app is launched in response to a notification.
            //userInfo: A dictionary of custom info to pass in the notification
            //attachments: An array of UNNotificationAttachment objects. Use to include audio, image or video content.
        
            //To Present image in notification
            if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
                let url = URL(fileURLWithPath: path)
                
                do {
                    let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("attachment not found.")
                }
            }
  ///------------------------------------------------------------------------------/////
            // Specific date time
            //-----------------------------****-------------------------------
           // let date = Date(timeIntervalSinceNow: 3600)
           // let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
            //                                            repeats: false)
            
            //-----------------------------****-------------------------------
            
            // Daily
            //-----------------------------****-------------------------------
            
            //let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date) // for daily used 3600 second
            // let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            //-----------------------------****-------------------------------
            
            
            // Weekly
            //-----------------------------****-------------------------------
            
           // let triggerWeekly = Calendar.current.dateComponents([.weekday,hour,.minute,.second,], from: date)
           // let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

            //-----------------------------****-------------------------------
            
            // Swift
            //-----------------------------****-------------------------------

            //  Location: Trigger when a user enters or leaves a geographic region. The region is specified through a CoreLocation CLRegion:
            
            // let trigger = UNLocationNotificationTrigger(triggerWithRegion:region, repeats:false)
            //-----------------------------****-------------------------------

  ///------------------------------------------------------------------------------/////
            
             // Deliver the notification in five seconds.
             let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
            
            //Set the request for the notification from the above
            let request = UNNotificationRequest(
                identifier: requestIdentifier,
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().delegate = self
            //Add the notification to the currnet notification center
            var center = UNUserNotificationCenter.current()
            center = customButton(center: center)
            center.add(request) { (error) in
                print(error ?? "")
            }
            
            print("should have been added")
        }
    }
    
    @IBAction func stopNotification(_ sender: AnyObject) {
        print("Removed all pending notifications")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
    }

    func customButton(center:UNUserNotificationCenter)-> UNUserNotificationCenter {
        // Swift
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                title: "Delete", options: [.destructive])
        // Swift
        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                              actions: [snoozeAction,deleteAction],
                                              intentIdentifiers: [], options: [])
        // Swift
        center.setNotificationCategories([category])
        return center
    }
}

extension ViewController:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")  
        default:
            print("Unknown action")
        }
        if response.notification.request.identifier == requestIdentifier {
            print("Tapped in notification")
            print(response)
        }
        print(response.notification.request.content.badge ?? "")
        completionHandler()
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification being triggered")
        if notification.request.identifier == requestIdentifier{
            
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = appDelegate.applicationbadge + 1
            appDelegate.applicationbadge = appDelegate.applicationbadge + 1
            completionHandler( [.alert,.sound,.badge])
        }
    }
}

