//
//  ViewController.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var noteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noteCollectionView: UICollectionView!
    @IBOutlet weak var questionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noQuestions: UILabel!
    @IBOutlet weak var noNotes: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var simulatedDeveloperBadge: UIView! {
        didSet {
            simulatedDeveloperBadge.layer.cornerRadius = 17.5
            simulatedDeveloperBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var developerNumber: UILabel!
    @IBOutlet weak var simulatedDesignBadge: UIView! {
        didSet {
            simulatedDesignBadge.layer.cornerRadius = 17.5
            simulatedDesignBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var designNumber: UILabel!
    @IBOutlet weak var simulatedBusinessBadge: UIView! {
        didSet {
            simulatedBusinessBadge.layer.cornerRadius = 17.5
            simulatedBusinessBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var businessNumber: UILabel!
    
    var questionService = QuestionService()
    var openedQuestions: [Question] = []
    var noteService = NoteService()
    var openedNotes: [Note] = []
    var topTimer: Timer!
    
    var screenSaverTimeInterval: TimeInterval? = nil
    var screenSaverViewController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = noteCollectionView.collectionViewLayout as? NoteCollectionViewLayout {
            layout.delegate = self
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        getAllQuestions()
        getAllNotes()
        refreshDate()
        refresHour()
        topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
                                        selector: #selector(ViewController.getAllInformations),
                                        userInfo: nil, repeats: true)
    }
    
    func verifyThatNeedActivateScreenSaver(with questions: [Question]) {
        if questions.count == 0 {
            DispatchQueue.main.async {
                self.questionActivityIndicator.stopAnimating()
                self.noQuestions.isHidden = false
                if let screenSaver = self.screenSaverTimeInterval {
                    if Date().timeIntervalSince1970 - screenSaver >= 30 {
                        self.performSegue(withIdentifier: "screenSaver", sender: nil)
                    }
                } else {
                    self.screenSaverTimeInterval = Date().timeIntervalSince1970
                }
            }
        } else {
            self.screenSaverTimeInterval = nil
            DispatchQueue.main.async {
                self.screenSaverViewController?.dismiss(animated: true, completion: {
                    self.screenSaverViewController = nil
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "screeSaver" {
            self.screenSaverViewController = segue.destination
        }
    }
    
    func getAllQuestions() {
        questionService.getAllQuestions(completion: {[weak self] (questions, error) in
            if error == nil {
                let questions = questions.sorted(by: { (question1, question2) -> Bool in
                    return question1.questionID < question2.questionID
                })
                self?.verifyThatNeedActivateScreenSaver(with: questions)
                if self?.openedQuestions != questions {
                    DispatchQueue.main.async {
                        if let viewController = self {
                            viewController.openedQuestions.removeAll()
                            viewController.openedQuestions = questions
                            viewController.questionTableView.reloadData()
                            viewController.questionActivityIndicator.stopAnimating()
                            viewController.developerNumber.text = String(viewController.lineNumber(questions, condition: { $0.categoryQuestion.type == .developer }))
                            viewController.designNumber.text = String(viewController.lineNumber(questions, condition: { $0.categoryQuestion.type == .design }))
                            viewController.businessNumber.text = String(viewController.lineNumber(questions, condition: { $0.categoryQuestion.type == .business }))
                            if viewController.openedQuestions.count == 0 {
                                viewController.noQuestions.isHidden = false
                            }
                            else {
                                viewController.noQuestions.isHidden = true
                            }
                        }
                    }
                }
            }
        })
    }
    
    func lineNumber(_ questions: [Question], condition: (Question)->Bool) -> Int {
        return questions.reduce(into: 0, { (result, question) in
            if condition(question) {
                result += 1
            }
        })
    }
    
    func getAllNotes() {
        noteService.getAllQuestions(completion: {[weak self] (notes, error) in
            if error == nil {
                let notes = notes.sorted(by: { (note1, note2) -> Bool in
                    return note1.noteID > note2.noteID
                })
                if notes.count == 0 || self?.openedNotes != notes {
                    self?.openedNotes.removeAll()
                    self?.openedNotes = notes
                    DispatchQueue.main.async {
                        self?.noteCollectionView.reloadData()
                        self?.noteCollectionView.collectionViewLayout.invalidateLayout()
                        self?.noteActivityIndicator.stopAnimating()
                        if self?.openedNotes.count == 0 {
                            self?.noNotes.isHidden = false
                        }
                        else {
                            self?.noNotes.isHidden = true
                        }
                    }
                }
            }
        })
    }
    
    
    @objc func getAllInformations() {
        getAllQuestions()
        getAllNotes()
        refreshDate()
        refresHour()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshDate() {
        self.dateLabel.text = Formatter.fullDateToString(Date())
    }
    
    func refresHour() {
        self.hourLabel.text = Formatter.currentHour()
    }
    
}

// MARK: - TableView functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.openedQuestions.count
        return openedQuestions.count
    }
    
    // Shows tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell
        
        
        
        if self.openedQuestions.count > 0 {
            cell?.profileName.text = self.openedQuestions[indexPath.row].username
            cell?.questionLabel.text = self.openedQuestions[indexPath.row].questionTitle
            cell?.numberLabel.text = "\(indexPath.row+1)"
            cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
            
            //Tirar o timestamp e colocar a data e hora
            let timeInterval = Double.init(self.openedQuestions[indexPath.row].questionID)
            let date = Date(timeIntervalSince1970: timeInterval! / 1000)
            let strDate = Formatter.dateToString(date)
            cell?.timeInputQuestion.text = strDate
            
            if(openedQuestions[indexPath.row].userPhoto != "") {
                let photoUrl = URL(string: openedQuestions[indexPath.row].userPhoto)!
                cell?.profileImage.kf.setImage(with: photoUrl)
            } else {
                cell?.profileImage.image = #imageLiteral(resourceName: "icons8-user_filled")
            }
            
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? QuestionTableViewCell
        cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return openedNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath)
        
        if let noteCell = cell as? NoteViewCell {
            noteCell.noteLabel.text = openedNotes[indexPath.row].noteText
            
            let strDate = Formatter.dateToString(openedNotes[indexPath.row].date)
            
            noteCell.nameLabel.text = "Username"
            noteCell.dateLabel.text = "\(strDate)"
//            noteCell.configureWidth(screenWidth)
        }
        
        return cell
    }
    
}

extension ViewController: NoteCollectionViewLayoutDelegate {
    
    func calculeColumn(width: CGFloat) -> CGFloat {
        return width - (noteCollectionView.contentInset.left + noteCollectionView.contentInset.right) - 20
    }
    
    func getAllTexts() -> [String] {
        return self.openedNotes.reduce([], {result, element in
            var result = result
            result.append(element.noteText)
            return result
        })
    }

}
