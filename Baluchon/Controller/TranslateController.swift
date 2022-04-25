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
    
    // MARK: Initialisation function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func translateButtonTouched() {
    }
}
