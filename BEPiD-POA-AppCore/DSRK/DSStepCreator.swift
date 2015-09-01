//
//  DSStepCreator.swift
//  RKRett
//
//  Created by Henrique Valcanaia on 8/20/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSStepCreator: NSObject {
    
    enum DSTaskTypes : String{
        case Number = "NSNumber"
        case Text = "String"
        case Query = "Query"
    }
    
    static let kDefaultStepIdentifier = "kDefaultStepIdentifier"
    static let kDefaultStepTitle = "kDefaultStepTitle"
    static let kDefaultStepAnswerUnit = "kDefaultStepAnswerUnit"
    static var defaultStep:ORKQuestionStep = ORKQuestionStep(identifier: DSStepCreator.kDefaultStepIdentifier, title: DSStepCreator.kDefaultStepTitle, answer: ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Decimal, unit: DSStepCreator.kDefaultStepAnswerUnit))
    
    static func createQuestionStepUsingDictionary(dictionary:NSDictionary) -> ORKQuestionStep{
        var step:ORKQuestionStep = ORKQuestionStep()
        
        let answerType:String = dictionary.valueForKey("answerType") as! String
        switch(answerType){
        case DSTaskTypes.Number.rawValue:
            step = DSStepCreator.createNumericQuestionStepUsingDictionary(dictionary)
            
        case DSTaskTypes.Text.rawValue:
            println("text")
//            step = DSStepCreator.createTextQuestionStepUsingDictionary(dictionary)
        
        case DSTaskTypes.Query.rawValue:
            step = DSStepCreator.createQueryStepUsingDictionary(dictionary)
            
        default:
            step = DSStepCreator.defaultStep
        }
        
        return step
    }
    
    private static func createQueryStepUsingDictionary(dictionary:NSDictionary) -> ORKQuestionStep{
        var step:ORKQuestionStep = ORKQuestionStep()
        return step
        
    }
    
    private static func createNumericQuestionStepUsingDictionary(dictionary:NSDictionary) -> ORKQuestionStep{
        var step:ORKQuestionStep
        let answerUnit = dictionary.objectForKey("answerUnit") as! String
        let answerFormat:ORKNumericAnswerFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Decimal, unit: answerUnit)
        
        if let answerRangeDic = dictionary.objectForKey("answerRange") as? NSDictionary{
            if let minimum = answerRangeDic.valueForKey("minimum") as? NSNumber{
                answerFormat.minimum = minimum
                if let maximum = answerRangeDic.valueForKey("maximum") as? NSNumber{
                    answerFormat.maximum = maximum
                }else{
                    println("Erro ao pegar o maximo")
                }
            }else{
                println("Erro ao pegar o minimo")
            }
        }
        
        let questionIdentifier = dictionary.objectForKey("questionId") as! String
        let prompt = dictionary.objectForKey("prompt") as! String
        step = ORKQuestionStep(identifier: questionIdentifier, title: prompt, answer: answerFormat)
        
        return step
    }
    
}
