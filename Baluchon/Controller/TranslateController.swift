//
//  TranslateController.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class TranslateController: UIViewController {
    // MARK: Public
    // MARK: Outlers
    @IBOutlet weak var textToTranslateView: TopRoundedTextView!
    @IBOutlet weak var translatedTextView: BottomRoundedTextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
        _sourceLanguagePickerContainer = UIView()
        _targetLanguagePickerContainer = UIView()
        _sourceLanguagePicker = UIPickerView()
        _targetLanguagePicker = UIPickerView()
        _delegateSetup()
        
        // Configure notification reception to update translated text view
        NotificationCenter.default.addObserver(self, selector: #selector(_updateTranslation), name: Notification.BaluchonNotification.updateTranslation.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_showAlertView), name: Notification.BaluchonNotification.errorDuringTranslating.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_showAlertView), name: Notification.BaluchonNotification.cannotDetectLanguage.notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_autoDetectionCompleted), name: Notification.BaluchonNotification.updateSourceLanguage.notificationName, object: nil)
        
        _addTapGestureRecogniser(to: sourceLanguageLabel, perform: #selector(displayPicker))
        _addTapGestureRecogniser(to: targetLanguageLabel, perform: #selector(displayPicker))
        _translation.getSupportedLanguages()
    }
    
    // MARK: Actions
    @IBAction func translateButtonTouched() {
        _translation.performTranlation(of: textToTranslateView.text)
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
    private let _translation = TranslationManager()
    private var _sourceLanguagePicker: UIPickerView!
    private var _targetLanguagePicker: UIPickerView!
    private var _sourceLanguagePickerContainer: UIView!
    private var _targetLanguagePickerContainer: UIView!
    private var _selectedPicker: Int = 0
    
    // MARK: Methods
    /// Adding a gesture recogniser to a view
    private func _addTapGestureRecogniser(to view: UIView, perform selector: Selector) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }
    
    /// Configure the toolbar with done button for keyboard and pickers
    private func _createDoneToolbar(with selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    /// Configure picker
    private func _configurePicker(height: Double) {
        _configurePickerView(_sourceLanguagePicker, height: height)
        _configurePickerView(_targetLanguagePicker, height: height)
        _configurePickerContainer(_sourceLanguagePickerContainer, for: _sourceLanguagePicker, heigh: height)
        _configurePickerContainer(_targetLanguagePickerContainer, for: _targetLanguagePicker, heigh: height)
    }
    
    /// Configure picker view
    private func _configurePickerView(_ picker: UIPickerView, height: Double) {
        picker.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        picker.backgroundColor = .init(named: "defaultBackground")
    }
    
    /// Configure the picker container
    private func _configurePickerContainer(_ container: UIView, for picker: UIPickerView, heigh: Double) {
        // Set up the picker container
        container.frame = CGRect(x: 0, y: self.view.bounds.height, width: view.bounds.width, height: heigh)
        
        container.addSubview(picker)
        container.addSubview(_configurePickerToolbar())
        view.addSubview(container)
    }
    
    /// Configure the toolbar with the "done" button for the picker
    private func _configurePickerToolbar() -> UIToolbar {
        let doneToolbar = _createDoneToolbar(with: #selector(_dismissPicker))
        doneToolbar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 45)
        return doneToolbar
    }
    
    /// Function called when the done button of the keyboard's toolbar is pressed
    private func _dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Get row id of the auto-detected language when the notification is received
    @objc private func _autoDetectionCompleted() {
        if let index = _translation.supportedSourceLanguages.firstIndex(where: {$0.language == _translation.sourceLanguage}) {
            pickerView(_sourceLanguagePicker, didSelectRow: index, inComponent: 0)
        }
    }
    
    /// Dismiss the picker
    @objc private func _dismissPicker() {
        UIView.animate(withDuration: 0.2) {
            self._targetLanguagePickerContainer.frame.origin.y = self.view.frame.height
            self._sourceLanguagePickerContainer.frame.origin.y = self.view.frame.height
        }
    }
    
    /// Display a UIPickerView
    @objc private func displayPicker(sender: UITapGestureRecognizer) {
        guard let selectedPickerTag = sender.view?.tag else { return }
        _selectedPicker = selectedPickerTag
        let pickerViewHeight = self.view.bounds.height / 3
        _configurePicker(height: pickerViewHeight)
        _dismissKeyboard()
        
        // Animation
        UIView.animate(withDuration: 0.2) {
            if selectedPickerTag == 1 {
                self._sourceLanguagePickerContainer.frame.origin.y = (self.view.frame.height - pickerViewHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0)/2)
            } else if selectedPickerTag == 2 {
                self._targetLanguagePickerContainer.frame.origin.y = (self.view.frame.height - pickerViewHeight - (self.tabBarController?.tabBar.frame.size.height ?? 0)/2)
            }
        }
    }
    
    /// Update the display when a notification is received
    @objc private func _updateTranslation() {
        DispatchQueue.main.async {
            self.translatedTextView.text = self._translation.translatedText
        }
    }
    
    /// Getting alert and show an UIAlert
    @objc private func _showAlertView(_ notification: Notification) {
        var message = "An unkown error occurs!"
        
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            if notificationName == Notification.BaluchonNotification.errorDuringTranslating.notificationName {
                message = Notification.BaluchonNotification.errorDuringTranslating.notificationMessage
            } else if notificationName == Notification.BaluchonNotification.cannotDetectLanguage.notificationName {
                message = Notification.BaluchonNotification.cannotDetectLanguage.notificationMessage
            }
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: Delegate extension
extension TranslateController: UIPickerViewDelegate, UITextViewDelegate {
    // MARK: Public method
    /// Called when an item is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            if pickerView == self._sourceLanguagePicker {
                let language = self._translation.supportedSourceLanguages[row]
                self.sourceLanguageLabel.text = "▼ \(language.name)"
                self._translation.sourceLanguage = language.language
            } else if pickerView == self._targetLanguagePicker {
                let language = self._translation.supportedTargetLanguages[row]
                self._translation.targetLanguage = language.language
                self.targetLanguageLabel.text = "\(language.name) ▼"
            }
        }
    }
    
    // MARK: Private method
    /// Setup delegates for this controller
    private func _delegateSetup() {
        _sourceLanguagePicker.delegate = self
        _targetLanguagePicker.delegate = self
        textToTranslateView.delegate = self
    }
}

// MARK: Data Source extension
extension TranslateController: UIPickerViewDataSource {
    // MARK: Public methods
    /// Return the number of column the picker will have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Return a cell of the picker. Called once per item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == _targetLanguagePicker {
            return "\(_translation.supportedTargetLanguages[row].name)"
        } else if pickerView == _sourceLanguagePicker {
            return "\(_translation.supportedSourceLanguages[row].name)"
        }
        return nil
    }
    
    /// Return the number of items in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == _targetLanguagePicker {
            return _translation.supportedTargetLanguages.count
        } else if pickerView == _sourceLanguagePicker {
            return _translation.supportedSourceLanguages.count
        }
        return 0
    }
    
    // MARK: Private method
}
