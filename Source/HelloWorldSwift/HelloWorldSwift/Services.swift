//
//  Services.swift
//  bicycle rent
//
//  Created by Nguyen Tran on 5/21/16.
//

import Foundation
import Alamofire
import SwiftyJSON
class Services: NSObject {
    func login(username:String,password:String,completion: (result: String)->Void){
        Alamofire.request(.POST, "http://192.168.100.3:8080/api/v1/auth", parameters: ["email" : username,
            "password" : password ])
            .responseJSON { response in
                
                if let value = response.result.value {
                    let json = JSON(value)
                    let accessToken:String = json["accessToken"].stringValue
                    if(accessToken=="")
                    {
                        
                    }
                    else
                    {
                        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
                        del.accessToken=accessToken
                        print("JSON: \(accessToken)")
                        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
                    }
                    completion(result: accessToken)
                }
        }
    }
    func register(username:String,password:String,completion: (result: String)->Void){
        Alamofire.request(.POST, "http://192.168.100.3:8080/api/v1/register", parameters: ["email" : username,
            "password" : password ])
            .responseJSON { response in
                
                if let value = response.result.value {
                    let json = JSON(value)
                    let accessToken:String = json["accessToken"].stringValue
                    if(accessToken=="")
                    {
                        
                    }
                    else
                    {
                        let del:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
                        del.accessToken=accessToken
                        print("JSON: \(accessToken)")
                        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
                    }
                    completion(result: accessToken)
                }
        }
    }
    func getPlaces(token:String,completion: (result: AnyObject)->Void)
    {
        let URL = "http://192.168.100.3:8080/api/v1/places"
        let headers = [
            "Authorization": token
        ]
        Alamofire.request(.GET, URL,headers:headers).responseObject { (response: Response<Result, NSError>) in
            let places = response.result.value
            let placeArray = places?.places
            if let array = placeArray {
                for place in array {
                    let location = place.location
                    print(place.id)
                    print(place.name)
                    print(location!.lat)
                    print(location!.lng)
                    
                }
                completion(result: places!)
            }
            
        }
    }
    func sendPayment(token:String,num:String,name:String,code:String,expire:String,completion: (result: Bool)->Void)
    {
        let URL = "http://192.168.100.3:8080/api/v1/rent"
        let headers = [
            "Authorization": token
        ]
        let paras = [
            "number": num,
            "name": name,
            "expiration": expire,
            "code": code
        ]
        Alamofire.request(.POST, URL,headers:headers,parameters:paras).responseString { (response: Response<String, NSError>) in
            let message = response.result.value
            if let error = response.result.error
            {
                completion(result: false)
            }
            else
            {
                completion(result:true)
            }
            print(message)
            
        }
    }
    
    
}
