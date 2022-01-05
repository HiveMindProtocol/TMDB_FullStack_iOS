//
//  networkManager.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

class networkManager: ObservableObject {
    @Published var curMov: JSON = [{}]
    @Published var topRateMov: JSON = [{}]
    @Published var popMov: JSON = [{}]
    @Published var airTV: JSON = [{}]
    @Published var popTV: JSON = [{}]
    @Published var topRateTV: JSON = [{}]
    @Published var main: JSON = [{}]
    @Published var detail: JSON = [{}]
    @Published var search: JSON = [{}]
    
    
    init(choice: Int, id: String = "", type: String = "", query: String = "") {
        switch choice {
        case 1:
            let block: (JSON) -> Void = { response in
                self.main = response
            }
            getHome(completionHandler: block)
        case 2:
            let block: (JSON) -> Void = { response in
                self.detail = response
            }
            getDetail(id: id, type: type, completionHandler: block)
        case 3:
            let block: (JSON) -> Void = { response in
                self.search = response["data"]
            }
            getSearch(query: query, completionHandler: block)
        default:
            break
        }
        
    }
    
    func get(choice: Int, id: String = "", type: String = "", query: String = "") {
        switch choice {
        case 1:
            let block: (JSON) -> Void = { response in
                self.main = response
            }
            getHome(completionHandler: block)
        case 2:
            let block: (JSON) -> Void = { response in
                self.detail = response
            }
            getDetail(id: id, type: type, completionHandler: block)
        case 3:
            let block: (JSON) -> Void = { response in
                self.search = response["data"]
            }
            getSearch(query: query, completionHandler: block)
        default:
            print("Error no network case")
        }
        
    }
    
    func home() {
        let block: (JSON) -> Void = { response in
            self.curMov = response["curMov"]["data"]
            self.topRateMov = response["topRateMov"]["data"]
            self.popMov = response["popMov"]["data"]
            self.airTV = response["airTV"]["data"]
            self.popTV = response["popTV"]["data"]
            self.topRateTV = response["topRateTV"]["data"]
        }
        getHome(completionHandler: block)
    }
    
    func detail(id: String, type: String) {
        let block: (JSON) -> Void = { response in
            self.detail = response
        }
        getDetail(id: id, type: type, completionHandler: block)
    }
    
    func search(query: String) {
        let block: (JSON) -> Void = { response in
            self.search = response["data"]
        }
        getSearch(query: query, completionHandler: block)
    }
    
    func getHome(completionHandler: @escaping (JSON) -> Void) {
        AF.request("http://nodejsapp-env-2.eba-fi4kzbds.us-east-2.elasticbeanstalk.com").responseJSON { (resp) -> Void in
            completionHandler(JSON(resp.data as Any))
        }
    }
    
    func getDetail(id: String, type:String, completionHandler: @escaping (JSON) -> Void) {
        AF.request("http://nodejsapp-env-2.eba-fi4kzbds.us-east-2.elasticbeanstalk.com/watch/" + type + "?id=" + id).responseJSON { (resp) -> Void in
            completionHandler(JSON(resp.data as Any))
        }
    }
    
    func getSearch(query: String, completionHandler: @escaping (JSON) -> Void) {
        let formatQuery = query.replacingOccurrences(of: " ", with: "%20")
        AF.request("http://nodejsapp-env-2.eba-fi4kzbds.us-east-2.elasticbeanstalk.com/search?query=" + formatQuery).responseJSON { (resp) -> Void in
            completionHandler(JSON(resp.data as Any))
        }
    }
}

