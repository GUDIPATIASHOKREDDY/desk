//
//  Httpwrapper.swift
//  Chomp
//
//  Created by Ashok Reddy G on 25/05/18.
//  Copyright © 2018 Ashok Reddy G. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "services.com": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}


class HttpWrapper {
    class func get(with url: String, parameters: [String : String]?, headers: [String : String]?, completionHandler: @escaping ([String : Any])->Void, errorHandler: @escaping ((Error))->Void) {
        let sessionManager = NetworkManager.sharedInstance.defaultManager
        sessionManager.session.configuration.timeoutIntervalForRequest = 1
            
            sessionManager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(headers: headers)).validate(statusCode: 200..<299).responseJSON { (response) in
                
                if response.result.isSuccess{
                    if (response.result.value as? [Any]) != nil{
                        //completionHandler(jsonResponse as! [[String : String]])
                        print(response)
                        completionHandler(response.result.value as! [String : String])
                    }else{
                        print(response)
                        completionHandler(response.result.value as! [String : Any])
                      //  completionHandler(response.result.value as! [[String : String]])
                      //  completionHandler(response.result.value as! [Any])
                        
                    }
                }else{
                    errorHandler(response.error!)
                }
        }
        
}
    class func gets(with url: String, parameters: [String : String]?, headers: [String : String]?, completionHandler: @escaping (Data?, Error?)->Void, errorHandler: @escaping ((Error))->Void) {
        
        let sessionManager = NetworkManager.sharedInstance.defaultManager
        sessionManager.session.configuration.timeoutIntervalForRequest = 1
       // _ = NetworkManager.sharedInstance.defaultManager
            
            sessionManager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(headers: headers)).validate(statusCode: 200..<299).responseJSON { (response) in
                  print(response)
                if response.result.isSuccess{
                    if (response.result.value as? [Any]) != nil{
                        //completionHandler(jsonResponse as! [[String : String]])
                        print(response)
                       
                         completionHandler(response.data, nil)
                        
                     //   completionHandler(response.result.value as! [String : String])
                    }else{
                         completionHandler(response.data, nil)
                        print(response)
                     //   completionHandler(response.result.value as! [String : Any])
                        //  completionHandler(response.result.value as! [[String : String]])
                        //  completionHandler(response.result.value as! [Any])
                        
                    }
                }else{
                    errorHandler(response.error!)
                }
        }
        
    }
    
    class func post(with url: String, parameters: [String : Any]?, headers: [String : String]?, completionHandler: @escaping (([String:Any]))->Void, errorHandler: @escaping ((Error))->Void) {
        let sessionManager = NetworkManager.sharedInstance.defaultManager
        sessionManager.session.configuration.timeoutIntervalForRequest = 1
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(headers: headers)).validate(statusCode: 200..<299).responseJSON { (response) in
            if response.result.isSuccess{
                if let jsonResponse = response.result.value as? [String:Any]{
                    completionHandler(jsonResponse)
                    //print(jsonResponse )
                }else{
        
                    
                
                   // completionHandler(response.result.value as! [String : Any])
                    //completionHandler((response.result.value as? [String:Any])!)
                    //print(response.error as! [String : Any])
                }
            }else{
                errorHandler(response.error!)
            }
        }
}
    class func posts(with url: String, parameters: [String : Any]?, headers: [String : String]?, completionHandler: @escaping (Data?, Error?)->Void, errorHandler: @escaping ((Error))->Void) {
        let sessionManager = NetworkManager.sharedInstance.defaultManager
        
        sessionManager.session.configuration.timeoutIntervalForRequest = 1
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(headers: headers)).validate(statusCode: 200..<299).responseJSON { (response) in
            
            if response.result.isSuccess{
                if (response.result.value as? [String:Any]) != nil{
                    // print(jsonResponse)
                    completionHandler(response.data, nil)
                   
                }else{
                     completionHandler(response.data, nil)
                   // print(response.data as Any)
                }
            }else{
                errorHandler(response.error!)
            }
        }
    }
    class func getJson(with url: String, parameters: [String : String]?, headers: [String : String]?, completionHandler: @escaping ([String: Any])->Void, errorHandler: @escaping ((Error))->Void) {
        let sessionManager = NetworkManager.sharedInstance.defaultManager
        
        sessionManager.session.configuration.timeoutIntervalForRequest = 1
            sessionManager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders(headers: headers)).responseJSON { (response) in
                if response.result.isSuccess{
                    if let jsonResponse = response.result.value as? [String: Any]{
                        completionHandler(jsonResponse)
                    }else{
                        // errorHandler(Error))
                    }
                }else{
                    errorHandler(response.error!)
                }
        }
    }
    class func searchLocations(query: String, completionHandler: @escaping ([String: Any])->Void, errorHandler: @escaping (Error)->Void){
        HttpWrapper.getJson(with: query, parameters: nil, headers: nil, completionHandler: { (response) in
            //
            completionHandler(response)
        }) { (error) in
            ///
            errorHandler(error)
        }
    }
    fileprivate class func getHeaders(headers: [String : String]?) -> [String : String]{
       
            var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders as [String : String]
            
            print(defaultHeaders)
            if let headers = headers{
                for header in headers {
                    defaultHeaders[header.key] = header.value
                    print(defaultHeaders)
                }
            }
            return defaultHeaders
        
    }
}

