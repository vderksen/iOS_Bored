// Student ID: 153803184
// Student name: Valentina Derksen
// https://github.com/vderksen/iOS_Bored

//  ActivityFetcher.swift
//  ValentinaDerksen_Bored
//
//  Created by Valya Derksen on 2021-04-20.
//

import Foundation

class ActivityFetcher: ObservableObject{
    
    var apiURL = "https://www.boredapi.com/api/activity"
    
    @Published var activityInfo = Activity()
    
    //singleton instance
    private static var shared : ActivityFetcher?
    
    static func getInstance() -> ActivityFetcher{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            // create a new singlton instance
            return ActivityFetcher()
        }
    }
    
    func fetchDataFromAPI(){
        guard let api = URL(string: apiURL) else {
            return
        }
        URLSession.shared.dataTask(with: api){ (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print(#function, "Could not fetch data", err)
            }else {
                // receive data or response
                
                DispatchQueue.global().async {
                    do {
                        if let jsonData = data {
                            let decoder = JSONDecoder()
                            // use this responce if array of JSON objects
                            let decodedList = try decoder.decode(Activity.self, from: jsonData)
                            // use this responce if JSON object
                            
                            DispatchQueue.main.async {
                                self.activityInfo = decodedList
                            }
                            
                        } else {
                            print(#function, "No JSON data received")
                        }
                        
                    } catch  let error {
                        print(#function, error)
                    }
                }
            }
        }.resume()
    }
}
