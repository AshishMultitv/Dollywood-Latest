////
////  AFNetworkingWebServices.swift
////  IntexTvApp
////
////  Created by Cybermac002 on 01/03/17.
////  Copyright © 2017 Multitv. All rights reserved.
////
//
//import UIKit
//import AFNetworking
//import CryptoSwift
//
//class AFNetworkingWebServices: NSObject
//{
//    func cancelOperation()  {
//        let manager = AFHTTPSessionManager()
//        manager.operationQueue.cancelAllOperations()
//    }
//    func postRequestAndGetResponse(urlString:NSString,param:NSDictionary,info:String)
//    {
//        //print("param>>>",param)
//        let responseDict:NSMutableArray=NSMutableArray()
//        let defaults = UserDefaults.standard
//        _ = defaults.value(forKey: info)
//        
//        let manager = AFHTTPSessionManager()
//        
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
//        let params = param
//      // print("param>>>",urlString,param)
//        manager.post(urlString as String, parameters:params, success:
//            {
//                
//                requestOperation, response in
//                
//              do
//                {
//                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
//                   // print("result>>>",result)
//                        do {
//                     //        print("signUp >>>",result)
//                        if result!["code"] as! Int == 1
//                        {
//                         //   print("signUp >>>",result)
//                            
//                            
//                                let keyString = "0123456789abcdef0123456789abcdef"
//                                let message = result!["result"] as! String
//                                    let encode =  message.aesDecrypt(key: keyString)
//                                    
//                                   
//                                    if info == "getLoginResponse" || info == "getOtpResponse" || info == "getFBLoginResponse" || info == "getFBSignUpResponse"  || info == "getHeartBeatResponse"
//                                    {
//                                         let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
//                                        let dictHome:NSMutableDictionary=NSMutableDictionary()
//                                        dictHome.setObject(jsonObject.mutableCopy() as! NSMutableDictionary, forKey: "result" as NSCopying)
//                                        dictHome.setObject(result!["code"], forKey: "code" as NSCopying)
//                                        
//                                        responseDict.add(dictHome)
//                                     //   print("result>>>>>>\(dictHome)")
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: dictHome)
//                                    }
//                                    else if  info == "getAppSessionResponse"
//                                    {
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: encode as NSString
//                                        )
//                                    }
//                                    else
//                                    {
//                                         let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
//                                        var dictHome:NSMutableDictionary=NSMutableDictionary()
//                                        dictHome=jsonObject.mutableCopy() as! NSMutableDictionary
//                                     //   print("result>>>>>>\(dictHome)")
//                                        
//                                        responseDict.add(dictHome)
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: jsonObject)
//                                    }
//                            
//                            
//                        }
//                        else
//                        {
//                         
//                            
//                            
//                        }
//                        
//                        
//                    }
//                }
//                catch
//                {
//                }
//
//            },
//                     failure:
//            {
//                requestOperation, error in
//        })
//                
//    }
//    func getRequestAndHeartResponse(urlString:NSString,param:NSDictionary,info:String)
//    {
//        //print("param>>>",param)
//        let responseDict:NSMutableArray=NSMutableArray()
//        let defaults = UserDefaults.standard
//        _ = defaults.value(forKey: info)
//        
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
//        let params = param
//        // print("param>>>",urlString,param)
//        manager.get(urlString as String, parameters:params, success:
//            {
//                
//                requestOperation, response in
//                
//                do
//                {
//                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
//                    do {
//                        //  print("signUp >>>",result)
//                        if result!["code"] as! Int == 1
//                        {
//                            let keyString = "0123456789abcdef0123456789abcdef"
//                            let message = result!["result"] as! String
//                            
//                            let encode =  message.aesDecrypt(key: keyString)
//                            
//                            
//                                let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
//                                let dictHome:NSMutableDictionary=NSMutableDictionary()
//                                dictHome.setObject(jsonObject.mutableCopy() as! NSMutableDictionary, forKey: "result" as NSCopying)
//                                dictHome.setObject(result!["code"], forKey: "code" as NSCopying)
//                                
//                            responseDict.add(dictHome)
//                            //   print("result>>>>>>\(dictHome)")
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: dictHome)
//                            
//                        }
//                        else
//                        {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
//                            )
//                        }
//                        
//                        
//                    }
//                }
//                catch
//                {
//                }
//                
//        },
//                    failure:
//            {
//                requestOperation, error in
//        })
//        
//        
//        
//        
//    }
//    func getRequestAndGetResponse(urlString:NSString,param:NSDictionary,info:String)
//    {
//        //print("param>>>",param)
//        let responseDict:NSMutableArray=NSMutableArray()
//        let defaults = UserDefaults.standard
//        _ = defaults.value(forKey: info)
//        
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        [manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")]
//        let params = param
//        // print("param>>>",urlString,param)
//        manager.get(urlString as String, parameters:params, success:
//            {
//                
//                requestOperation, response in
//                
//                do
//                {
//                    let result = try JSONSerialization.jsonObject(with: (response as! NSData) as Data, options: []) as? NSDictionary
//                    do {
//                      //  print("signUp >>>",result)
//                        if result!["code"] as! Int == 1
//                        {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
//                            )
//                            
//                        }
//                        else
//                        {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: info), object: result! as NSDictionary
//                            )
//                        }
//                        
//                        
//                    }
//                }
//                catch
//                {
//                }
//                
//        },
//                     failure:
//            {
//                requestOperation, error in
//        })
//        
//        
//        
//        
//    }
//
//
//}
