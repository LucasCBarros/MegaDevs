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
    
    // Remove LineData from User
    func removeQuestionFromLine(lineName: String, question: QuestionProfile, completionHandler: @escaping (Error?) -> Void) {
        questionProfileManager.removeQuestionFromLine(question: question, completionHandler: {(error) in
            
            completionHandler(error)
        })
    }

    ///:BAD CODE - Will retrieve all questions
    // Return all open questions
    func retrieveOpenQuestionsBySubject(lineName: String, completion: @escaping ([QuestionProfile]?) -> Void) {
        questionProfileManager.retrieveAllOpenQuestions(completionHandler: {(allQuestions)  in
            let filteredQuestions = allQuestions?.filter({ (question) -> Bool in
                return question.requestedTeacher == lineName
            })
            
            if let questions = filteredQuestions {
                completion(questions.sorted { $0.createdAt < $1.createdAt })
            } else {
                completion(filteredQuestions)
            }
        })
    }
    
    func retrieveAllOpenQuestions(completion: @escaping ([QuestionProfile]?) -> Void) {
        questionProfileManager.retrieveAllOpenQuestions(completionHandler: {(allQuestions)  in
            
            if let questions = allQuestions {
                completion(questions.sorted { $0.createdAt < $1.createdAt })
            } else {
                completion(allQuestions)
            }
        })
    }
    
    // Create a question
    func createQuestion(user: UserProfile, questionTxt: String, requestedTeacher: String) {
        questionProfileManager.createQuestion(user: user,
                                              questionTxt: questionTxt,
                                              requestedTeacher: requestedTeacher)
    }
}
