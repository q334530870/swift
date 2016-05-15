//
//	Weather.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Weather{
    
    var result : [WeatherResult]!
    var success : String!
    
    
    /**
     * 用字典来初始化一个实例并设置各个属性值
     */
    init(fromDictionary dictionary: NSDictionary){
        result = [WeatherResult]()
        if let resultArray = dictionary["result"] as? [NSDictionary]{
            for dic in resultArray{
                let value = WeatherResult(fromDictionary: dic)
                result.append(value)
            }
        }
        success = dictionary["success"] as? String
    }
    
}