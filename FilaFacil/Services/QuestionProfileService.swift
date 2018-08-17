//
//  QuestionProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class QuestionProfileService: NSObject {
   
    let questionProfileManager = QuestionProfileDAO()
    
    // Returns the question associated with the current User
    func retrieveUsersQuestion(questionID: String, completion: @escaping (QuestionProfile?) -> Void) {
       questionProfileManager.retrieveUsersQuestion(questionID: questionID, completionHandler: completion)
    }
    
    func retrieveCurrentQuestion(questionID: String, completion: @escaping (QuestionProfile?) -> Void) {
        questionProfileManager.retrieveCurrentQuestion(questionID: questionID, completionHandler: completion)
    }
    
    // Return all open questions
    func retrieveAllOpenQuestions(lineName: String, completion: @escaping ([QuestionProfile]?) -> Void) {
        questionProfileManager.retrieveAllOpenQuestions(lineName: lineName, completionHandler: completion)
    }
    
    // Create a question
    func createQuestion(userID: String, questionTxt: String, username: String, requestedTeacher: String, userPhoto: String) {
        questionProfileManager.createQuestion(userID: userID,
                                              questionTxt: questionTxt,
                                              username: username,
                                              requestedTeacher: requestedTeacher,
                                              userPhoto: userPhoto)
    }
    
    // Update Question
    func updateQuestion(editedQuestion: QuestionProfile, newText: String, newLineName: String, oldLineName: String) {
        questionProfileManager.updateQuestion(editedQuestion: editedQuestion, newText: newText, newLineName: newLineName, oldLineName: oldLineName)
    }
}
