//
//  JournalDailyViewController.swift
//  JournalDaily
//
//  Created by Hayden Hastings on 4/3/17.
//  Copyright © 2017 Hayden Hastings. All rights reserved.
//

import UIKit
import CloudKit
import Speech

class JournalDailyViewController: UIViewController, SFSpeechRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var journal: JournalDaily?
    var cloudKitManager = CloudKitManager()
    
    @IBOutlet weak var journalPictureImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let journal = journal {
            updateViews(journal: journal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        if let journal = journal {
            updateViews(journal: journal)
        }
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.journalTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        addImageButton.setTitle("", for: .normal)
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true) {
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text,
            let journalText = journalTextView.text,
            let photo = journalPictureImageView.image,
            let photoData = UIImageJPEGRepresentation(photo, 0.5)
            else { return }
        
        if let journal = self.journal {
            // update journal
            journal.title = title
            journal.journalText = journalText
            journal.photoData = photoData
            
            // save to cloudKit
            JournalDailyController.shared.update(journal: journal)
            
        } else {        // create new entry
            
            JournalDailyController.shared.createJournal(image: photo, title: title, journalText: journalText) { (error) in
                
                if let error = error {
                    print(error)
                }
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func dismissKeyboard() {
        titleTextField.resignFirstResponder()
        journalTextView.resignFirstResponder()
    }
    
    @IBAction func keyboardViewTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            journalPictureImageView.image = image
        } else {
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews(journal: JournalDaily) {
        self.journal = journal
        //        guard let journal = journal else { return }
        titleTextField.text = journal.title
        journalPictureImageView.image = journal.photo
        journalTextView.text = journal.journalText
    }
}
