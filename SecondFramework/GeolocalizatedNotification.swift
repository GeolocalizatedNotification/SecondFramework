//
//  GeolocalizatedNotification.swift
//  Framework
//
//  Created by Miguel Pimentel on 31/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import MapKit

public class GeolocalizatedNotification: UIViewController, CLLocationManagerDelegate {
    
    
    
    // MARK: - Manager localization
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    public override init() {
    }
    
    public func notificateWhenInLocation(latitude: Double , longitude: Double, radius: Double, identifier: String) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        requestLocationAuthorization()
        startToMonitoringUser(latitude: latitude, longitude: longitude, radius: radius, identifier: identifier)
        requestAuthorizationWhileInUsage()
    }
    
    private func requestLocationAuthorization() {
        
        locationManager.requestAlwaysAuthorization()
    }
    
    private func startToMonitoringUser(latitude: Double, longitude: Double, radius: Double, identifier: String) {
        
        let centerLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let currentRegion =  CLCircularRegion(center: centerLocation, radius: radius, identifier: identifier)
        
        locationManager.startMonitoring(for: currentRegion)
    }
    
    private func requestAuthorizationWhileInUsage() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: -  Notification
    
    public func geolocalizatedNotification(notificationTitle: String, notificationContent: String) {
        
        let timeToNotificate:  TimeInterval = 5
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeToNotificate, repeats: false)
        let content = createContent(title: notificationTitle, body: notificationContent)
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        requestANewNotification(request: request)
    }
    
    
    
    private func requestForNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            didAllow, error in
            
        })
        
    }
    
    private func createContent(title: String, body: String) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    private func requestANewNotification(request: UNNotificationRequest) {
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    
    
}
