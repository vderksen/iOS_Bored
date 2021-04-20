// Student ID: 153803184
// Student name: Valentina Derksen
// https://github.com/vderksen/iOS_Bored

//  Activity.swift
//  ValentinaDerksen_Bored
//
//  Created by Valya Derksen on 2021-04-20.
//

import Foundation


struct Activity : Codable {
    var activity : String
    
    init(){
        self.activity = " "
    }
    
    enum CodingKeys : String, CodingKey {
        case activity = "activity"
    }
    
    func encode(to encoder: Encoder) throws {
        // nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try response.decodeIfPresent(String.self, forKey: .activity) ?? "Unavailable"
    }
}
