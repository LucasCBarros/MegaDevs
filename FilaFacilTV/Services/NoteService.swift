//
//  QuestionService.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class NoteService {
    
    func getAllQuestions(completion: @escaping (_ questions: [Note], _ error: Error?) -> Void) {
        let URL: String = "https://filafacildev.firebaseio.com/Notes.json"
        
        //creating a NSURL
        guard let url = NSURL(string: URL) else { return }
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL), completionHandler: {(data, response, error) in
            
            guard let data = data else { return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
                //TODO: Código inútil?
//                let jsonString = ("\(json.keys)")
                
//                let jsonData = jsonString.data(using: .utf8)! // Conversion to UTF-8 cannot fail.
                
                var notes: [Note] = []
                
                for (_, elem) in json{
                    print(elem)
                    let jsonQuestion = elem as? [String: Any]
                    notes.append(Note(json: jsonQuestion!))
                }
                
                completion(notes, nil)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }).resume()
        
    }
}
