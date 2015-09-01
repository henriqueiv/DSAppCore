//
//  DSTask.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 8/20/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSTask: DSReflect {
    
    var taskId:String!
    var name:String!
    var file:String!
    var frequencyNumber:NSNumber!
    var frequencyType:String!
    var questions:[DSQuestion] = [DSQuestion]()
    
    init(plistFileName:String){
        super.init()
        self.file = plistFileName
        if let path = NSBundle.mainBundle().pathForResource(plistFileName, ofType: "plist") {
            if let taskDictionary = NSDictionary(contentsOfFile: path){
                let properties = self.properties()
                for property in properties{
//                    println("DSTask.\(property)")
                    switch(property){
                        
                    case "file":
                        continue
                        
                    case "questions":
                        if let questionsArray = taskDictionary.objectForKey(property) as? NSArray{
                            for questionDictionary in questionsArray as! [NSDictionary]{
                                let question = DSQuestion(questionDictionary: questionDictionary)
                                questions += [question]
                            }
                        }else{
                            println("error unwrapping questions array in DSTask")
                        }
                        
                    default:
                        println("default: \(property)")
                    }
                    
                    let propertyValue: AnyObject? = taskDictionary.objectForKey(property)
                    assert(propertyValue != nil, "\(property) in task \(self.name) is nil")
                    self.setValue(propertyValue, forKey: property)
                }
            }
        }
    }
    
}