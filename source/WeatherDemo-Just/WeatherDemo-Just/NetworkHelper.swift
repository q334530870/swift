//
//  NetworkHelper.swift
//  WeatherDemo-Just
//
//  Created by YaoJ on 16/5/13.
//  Copyright © 2016年 瑶瑾瑾. All rights reserved.
//
import Foundation

enum NetworkHelper{
    
    case WeeklyWeather(cityId:String)
    
    static var param = [
        "app":"weather.future",
        "appkey":"10003",
        "sign":"b59bc3ef6191eb9f747dd4e83c99f2a4",
        "format":"json"
    ]
    
    static let baseUrl = "http://api.k780.com:88"
    
    func getWeather(completion: ([WeatherResult]?, String?) ->Void){
        var error = ""
        var results: [WeatherResult]?
        
        switch self {
        case .WeeklyWeather(cityId: let weaid):
            
            NetworkHelper.param["weaid"] = weaid
            
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.param, asyncCompletionHandler: {(r) in
                if r.ok{
                    //利用guard确保返回结果是json类型
                    guard let jsonDict = r.json as? NSDictionary else{
                        
                        error = "返回的不是json字符串"
                        return
                    }
                    //确保字典中的success字段的值为1
                    guard let success = jsonDict["success"] where success as? String == "1" else{
                        error = "返回数据格式不对，或者授权错误"
                        return
                    }
                    
                    let weather = Weather(fromDictionary: jsonDict)
                    results = weather.result
                }
                else{
                    error = "服务器出错"
                }
                //调用完成后的回调方法
                completion(results,error)
            })
        }
        
        
        
    }
}
