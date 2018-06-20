//
//  UserProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class UserProfileService: NSObject {
    
    let userProfileManager = UserProfileDAO()
    
    /// AuthBase functions:
    // Register - Creates new user
    func createUser(userID: String, username: String, profileType: String,
                    email: String, questionID: String) {
        userProfileManager.createUserProfile(userID: userID, username: username,
                                             profileType: profileType, email: email,
                                             questionID: questionID)
    }
    
    // Login - Retrieve user info
    func retrieveUser(userID: String, completionHandler: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveUserProfile(userID: userID) { (user) in
            if let currUser = user {
                completionHandler(currUser)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /// Other functions:
    
    // Retrieve Current User
    func retrieveCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveCurrentUserProfile(completionHandler: completion)
    }
    
    // Remove LineData from User
    func removeQuestionFromLine(lineName: String, questionID: String) {
        userProfileManager.removeQuestionFromLine(lineName: lineName, questionID: questionID)
    }
    
    func filterLineByTab(allQuestions: [QuestionProfile], selectedTab: String) -> ([QuestionProfile]) {
        var questionsInLine: [QuestionProfile] = []
        for question in allQuestions where (question.requestedTeacher == selectedTab) {
                questionsInLine.append(question)
        }
        return questionsInLine
    }
}
