//
//  ViewController.swift
//  Pset3
//
//  Created by Mert Arıcan on 5.03.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var model = SEPModel()
        
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.layer.cornerRadius = 8.0
            textField.layer.borderWidth = 3.0
            textField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            textField.clipsToBounds = true
            textField.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 8.0
            button.layer.borderWidth = 3.0
            button.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    let scrollView = UIScrollView()
    
    @IBOutlet weak var templateView: UIView!
    
    var resultLabel = UILabel()
    
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            setInfoLabel()
        }
    }
    
    // 758 is the champion.
    @IBAction private func calculate(_ sender: UIButton?=nil) {
        var results: [[String]]
        
        // Values more than n takes time.
        if let text = textField.text, let n = Int(text), n > 1 && n <= 1001 {
            results = model.calcSolution(for: n)
        } else { return }
        
        // Trash code but works and time is valuable.
        func getDesc(x: [String]) -> String {
            var str = "("
            x.forEach { str += $0 + ", " }
            for _ in 1...2 { str.removeLast() }
            str += ")\n"
            var l = str.lastIndex(of: ",")!
            str.insert(";", at: l)
            l = str.lastIndex(of: ",")!
            str.remove(at: l)
            return str
        }
        
        var text = String()
        for result in results {
            text += getDesc(x: result)
        }
        self.resultLabel.text = text
        setInfoLabel()
        model.clearModel()
        textField.resignFirstResponder()
    }
    
    private func setInfoLabel() {
        self.countLabel.text = "Total number of calls: \(model.totalCount)\n"
        self.countLabel.text! += "Calls from memory: \(model.memoCount)\n"
        self.countLabel.text! += model.totalCount == 0 ? "Percentage of memory usage: %0" : "Percentage of memory usage: %\(model.memoCount * 100 / model.totalCount)"
        resultLabel.sizeToFit()
        let height = max(resultLabel.bounds.height, scrollView.bounds.height) // Needed this to vertically center text.
        resultLabel.frame = CGRect(origin: scrollView.bounds.origin, size: CGSize(width: scrollView.bounds.width, height: height))
        scrollView.contentSize = CGSize(width: 10.0, height: resultLabel.bounds.size.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        calculate()
        textField.resignFirstResponder()
        return true
    }
      
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(scrollView)
        scrollView.frame = templateView.frame
        templateView.removeFromSuperview()
        scrollView.addSubview(resultLabel)
        resultLabel.frame = scrollView.bounds
        resultLabel.textColor = .white
        resultLabel.numberOfLines = 0
        resultLabel.font = .systemFont(ofSize: 30.0)
        resultLabel.textAlignment = .center
        scrollView.contentSize = CGSize(width: 0.0, height: resultLabel.bounds.size.height)
    }
    
}
