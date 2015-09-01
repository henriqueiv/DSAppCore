//
//  DSQuestion.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 8/27/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSQuestion: DSReflect {
    
    var answerUnit:String?
    var answerRange:NSDictionary?
    var answerType:String?
    var prompt:String?
    var questionId:String?
    var dashboard:NSDictionary?
    
    init(questionDictionary:NSDictionary){
        super.init()
        let properties = self.properties()
        for property in properties{
            let value = questionDictionary.objectForKey(property)
            switch(property){
            case "answerRange":
                // value has a dictionary
                if let valueDictionary = value as? NSDictionary{
                    answerRange?.setValue(valueDictionary.objectForKey("minimum"), forKey: "minimum")
                    answerRange?.setValue(valueDictionary.objectForKey("maximum"), forKey: "maximum")
                    continue
                }
            case "dashboard":
                // value has a dictionary
                if let valueDictionary = value as? NSDictionary{
                    dashboard?.setValue(valueDictionary.objectForKey("graphicType"), forKey: "graphicType")
                    dashboard?.setValue(valueDictionary.objectForKey("xAxisColName"), forKey: "xAxisColName")
                    dashboard?.setValue(valueDictionary.objectForKey("yAxisColName"), forKey: "yAxisColName")
                    continue
                }
//                println(property)
                
            default:
                println(property)
                
            }
            self.setValue(value, forKey: property)
        }
    }
    
}
