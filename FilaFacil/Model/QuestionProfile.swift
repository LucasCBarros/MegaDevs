//
//  QuestionProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class QuestionProfile: NSObject, PersistenceObject {

    // Writen by user
    var questionTitle: String = ""
    
    // TimeStamp to make ID
    var questionID: String = ""
    
    // UserID from Firebase
    var userID: String = ""
    
    // Username from Firebase
    var username: String = ""
    
    // Empty or one of the existing
    var requestedTeacher: String = ""
    
    // Empty or one of the existing
    var userPhoto: String = ""
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]
    
    static func == (left: QuestionProfile, right: QuestionProfile) -> Bool {
        return left.questionID == right.questionID && left.questionTitle == right.questionTitle
    }
    
    static func != (left: QuestionProfile, right: QuestionProfile) -> Bool {
        return !(left == right)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? QuestionProfile {
            return self == object
        } else {
            return false
        }
    }
    required init(dictionary: [AnyHashable: Any]) {
        
        if let questionTitle = dictionary["questionTitle"] as? String {
            self.questionTitle = questionTitle
        }
        if let questionID = dictionary["questionID"] as? String {
            self.questionID = questionID
        }
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let requestedTeacher = dictionary["requestedTeacher"] as? String {
            self.requestedTeacher = requestedTeacher
        }
        if let userPhoto = dictionary["userPhoto"] as? String {
            self.userPhoto = userPhoto
        }
        self.dictInfo = dictionary
    }
    
    init(questionTitle: String, questionID: String, userID: String, username: String, requestedTeacher: String, userPhoto: String) {
        self.questionTitle = questionTitle
        self.questionID = questionID
        self.userID = userID
        self.username = username
        self.requestedTeacher = requestedTeacher
        self.userPhoto = userPhoto
        self.dictInfo = [
            "questionTitle": questionTitle,
            "questionID": questionID,
            "userID": userID,
            "username": username,
            "requestedTeacher": requestedTeacher,
            "userPhoto": userPhoto
        ]
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
    
}
