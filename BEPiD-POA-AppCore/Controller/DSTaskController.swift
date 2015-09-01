//
//  DSTaskViewController.swift
//  RKRett
//
//  Created by Henrique Valcanaia on 8/20/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSTaskController: NSObject {
    
    var parentViewController: UIViewController!
    var taskViewControllerInstance: ORKTaskViewController!
    
    func createTaskWithDictionary(dictionary:NSDictionary, andParentViewController parentViewController:UIViewController, willShowTask showTask:Bool = false){
        self.parentViewController = parentViewController
        self.taskViewControllerInstance = ORKTaskViewController(task: DSTaskCreator(dictionary), taskRunUUID: nil)
        self.taskViewControllerInstance.delegate = self
        if showTask{
            self.showTask()
        }else{
            println("Parameter 'showTask' is false, you must call showTask() to present the taskViewController")
        }
    }
    
    func showTask(){
        let requiredProperties = ["parentViewController", "taskViewControllerInstance"]
        for prop in requiredProperties{
            if self.respondsToSelector(NSSelectorFromString(prop)){
                assert(self.valueForKey(prop) != nil, "You shoud set the property '\(prop)' in DSTaskController in order to show the task")
            }
        }
        self.parentViewController.presentViewController(self.taskViewControllerInstance, animated: true, completion: nil)
    }
    
    //MARK: - Utils
    func resultsArrayToDictionary(results: NSArray) -> NSDictionary{
        var dict = NSMutableDictionary()
        for stepResultAux in results {
            if let stepResult = stepResultAux as? ORKStepResult{
                if let result = stepResult.results?.first{
                    let answerKey = getAnswerKeyForResult(result as! ORKResult)
                    assert(result.respondsToSelector(NSSelectorFromString(answerKey)), "Result '\(NSStringFromClass(result.classForCoder))' doesn't respond to selector '\(answerKey)'")
                    if let value = result.valueForKey(answerKey){
                        dict.setObject(value, forKey: result.identifier)
                    }else{
                        println("Error getting value for key '\(result.identifier)'")
                    }
                }
            }
        }
        return dict
    }
    
    func getAnswerKeyForResult(result:ORKResult) -> String{
        var answerKey = ""
        
        switch(result){
        case let x where x is ORKNumericQuestionResult:
            answerKey = "numericAnswer"
            
        default:
            answerKey = ""
        }
        return answerKey
    }
    
    func resultsDictionaryToJSONObject(dictionary:NSDictionary) -> AnyObject?{
        var jsonError: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(ORKESerializer.JSONDataForObject(dictionary, error: &jsonError), options: nil, error: &jsonError){
            if let unwrappedError = jsonError {
                println("json error: \(unwrappedError.localizedDescription)")
            } else {
                return json
            }
        }
        return nil
    }
    
    func JSONObjectToString(jsonObject:AnyObject) -> NSData?{
        var err = NSErrorPointer()
        let data = NSJSONSerialization.dataWithJSONObject(jsonObject, options: nil, error: err)
        return data
    }
    
}

//MARK: - ORKTaskViewControllerDelegate
extension DSTaskController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        println("stepViewControllerWillAppear")
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch(reason){
        case ORKTaskViewControllerFinishReason.Completed:
            println("Completed")
            
            if let results = taskViewController.result.results{
                let dictionary = resultsArrayToDictionary(results)
                if let json: AnyObject = resultsDictionaryToJSONObject(dictionary){
                    if let jsonString = JSONObjectToString(json){
                        let taskAnswer = DSTaskAnswer()
                        taskAnswer.json = PFFile(name: "\(NSDate().stringDateWithFormat()).json", data: jsonString, contentType: "json")
                        taskAnswer.taskName = taskViewController.task?.identifier
                        taskAnswer.saveInBackgroundWithBlock({ (result, error) -> Void in
                            if error == nil{
                                self.taskViewControllerInstance.dismissViewControllerAnimated(true, completion: nil)
                            } else{
                                println("Error while saving task answer! \(error?.localizedDescription)")
                            }
                        })
                    }
                }
            }
            
        case ORKTaskViewControllerFinishReason.Discarded:
            println("Discarded")
            self.taskViewControllerInstance.dismissViewControllerAnimated(true, completion: nil)
            
        case ORKTaskViewControllerFinishReason.Failed:
            println("Failed: \(error?.localizedDescription)")
            self.taskViewControllerInstance.dismissViewControllerAnimated(true, completion: nil)
            
        case ORKTaskViewControllerFinishReason.Saved:
            println("Saved")
            self.taskViewControllerInstance.dismissViewControllerAnimated(true, completion: nil)
            
        default:
            println("Default")
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, recorder: ORKRecorder, didFailWithError error: NSError) {
        println("didFailWithError \(error.localizedDescription)")
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}