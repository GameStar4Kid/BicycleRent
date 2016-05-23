//
//  Place.swift
//  push-demo
//
//  Created by Nguyen Tran on 5/21/16.
//  Copyright © 2016 AJ ONeal Tech LLC. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
class Result: Mappable {
    var places:Array<Place>?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        places <- map["results"]
    }
}

class Place: Mappable {
    var location: Location?
    var id: String?
    var name: String?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        id <- map["id"]
        name <- map["name"]
    }
}
class Location: Mappable {
    var lat: Double?
    var lng: Double?
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}