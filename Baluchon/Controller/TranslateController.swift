//
//  TranslateController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class TranslateController: UIViewController, UITextViewDelegate {
    // MARK: Public
    // MARK: Outlers
    @IBOutlet weak var textToTranslateView: TopRoundedTextView!
    @IBOutlet weak var translatedTextView: BottomRoundedTextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        textToTranslateView.delegate = self
        
        // Configure notification reception to update translated text view
        NotificationCenter.default.addObserver(self, selector: #selector(updateTranslation), name: Notification.BaluchonNotification.updateTranslation.notificationName, object: nil)
    }
    
    // MARK: Actions
    @IBAction func translateButtonTouched() {
        translation.performTranlation(of: textToTranslateView.text)
    }
    
    // MARK: Methods
    /// Called every time the textField is changed to hide or display a placeholder
    func textViewDidChange(_ textView: UITextView) {
        if textToTranslateView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let translation = Translation()
    
    // MARK: Methods
    /// Update the display when a notification is received
    @objc private func updateTranslation() {
        DispatchQueue.main.async {
            self.translatedTextView.text = self.translation.translatedText
        }
    }
}
