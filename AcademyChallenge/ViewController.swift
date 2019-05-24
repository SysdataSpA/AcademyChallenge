//
//  ViewController.swift
//  AcademyChallenge
//
//  Created by Guido Sabatini on 21/05/2019.
//  Copyright © 2019 Sysdata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // UI setup
    private func setup() {
        // visualizzazione delle prime label
        let label1 = createLabel(with: "intro_text1")
        label1.font = UIFont.boldSystemFont(ofSize: 20)
        self.stackView.insertArrangedSubview(label1, at: 0)
        
        let label2 = createLabel(with: "intro_text2", delay: 3)
        label2.font = UIFont.systemFont(ofSize: 20)
        self.stackView.insertArrangedSubview(label2, at: 1)
        
        let label3 = createLabel(with: "intro_text3", delay: 4)
        label3.font = UIFont.systemFont(ofSize: 20)
        self.stackView.insertArrangedSubview(label3, at: 2)
        UserDefaults.standard.set(String(stackView.tag), forKey: obf)
    }
    
    //MARK: - IBActions
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let code = textField.text, Helper.md5(code) == obf {
            end(with: code)
        } else {
            pulse(color: .red)
        }
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("info", comment: ""), message: NSLocalizedString("info_text", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    
    //MARK: Utilities
    
    // make background pulse by color
    func pulse(color: UIColor) {
        self.view.backgroundColor = color
        UIView.animate(withDuration: 1.0) { 
            self.view.backgroundColor = .white
        }
    }
    
    // creates a label with a certain localizable content and a fading animation
    func createLabel(with textKey:String?, delay: TimeInterval = 0) -> UILabel {
        let label = UILabel(frame: .zero)
        if let key = textKey {
            label.text = NSLocalizedString(key, comment: "")
        }
        label.alpha = 0
        label.numberOfLines = 0
        label.textAlignment = .center
        
        UIView.animate(withDuration: 1.0, delay: delay, options: .allowUserInteraction, animations: { 
            label.alpha = 1
        }, completion: nil)
        
        return label;
    }
    
    // all ending animations
    func end(with code: String) {
        pulse(color: .green)
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        view.addSubview(confettiView)
        if let image = UIImage(named: "confetti") {
            confettiView.type = .image(image)
        }
        confettiView.startConfetti()
        textField.resignFirstResponder()
        
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        let labelIntro = createLabel(with: "result_text1")
        labelIntro.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(labelIntro)
        
        let labelCode = createLabel(with: nil)
        labelCode.font = UIFont.boldSystemFont(ofSize: 40)
        labelCode.text = code
        stackView.addArrangedSubview(labelCode)
        
        let labelOutro = createLabel(with: "result_text2")
        labelOutro.font = UIFont.systemFont(ofSize: 20)
        stackView.addArrangedSubview(labelOutro)
    }
}
