//
//  ViewController.swift
//  $125 Million App
//
//  Created by CSOM on 1/28/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    struct Formula {
        var conversionString: String
        var formula: (Double) -> Double
    }
    
    // MARK : Properties
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var posNeg: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "miles to kilometers", formula: {$0 / 0.62137}),
                        Formula(conversionString: "kilometers to miles", formula: {$0 * 0.62137}),
                        Formula(conversionString: "feet to meters", formula: {$0 / 3.2808 }),
                        Formula(conversionString: "yard to meters", formula: {$0 / 1.0936}),
                        Formula(conversionString: "meters to feet", formula: {$0  * 3.2808}),
                        Formula(conversionString: "meters to yards", formula: {$0 * 1.0936}),
                        Formula(conversionString: "inches to centimeters", formula: {$0 / 0.39370}),
                        Formula(conversionString: "centimeters to inches", formula: {$0 * 0.39370}),
                        Formula(conversionString: "fahrenheit to celsius", formula: {$0 - 32 * (5/9)}),
                        Formula(conversionString: "celsius to fahrenheit", formula: {$0 * (9/5) + 32}),
                        Formula(conversionString: "quarts to liters", formula: {$0 / 1.05669}),
                        Formula(conversionString: "liters to quarts", formula: {$0 * 1.05669})]

    
    var toUnits = ""
    var fromUnits = ""
    var conversionString = ""
    var rowSelected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        userInput.delegate = self
        
        
        conversionString = formulasArray[0].conversionString
        
        assignunits()
        
        userInput.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignunits() {
        let unitsArray = conversionString.components(separatedBy: " to ")
        
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        
    }
    
    func showAlert(title: String, message: String) {
        //perform the four-step process to create alert, create an action, assign an action to the alert, and press the alert.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resultsLabel.text = ""
        posNeg.selectedSegmentIndex = 0
        return true
    }
    
    func calculateConversion() {
        
        var inputValue = 0.0
        var outputValue = 0.0
         var outputString = ""
        
        if let inputValue = Double(userInput.text!) {
            outputValue = formulasArray[rowSelected].formula(inputValue)
        } else {
            showAlert(title: "Error", message: "Please be sure to only enter numbers, no commas, symbols, or non-numeric characters.")
        }
        
        if decimalSegment.selectedSegmentIndex < 3 {
        outputString = String(format: "%." + String(decimalSegment.selectedSegmentIndex+1) + "f", outputValue)
        } else {
        outputString = String(outputValue)
        }
        
        resultsLabel.text = "\(userInput.text!) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    
    // MARK:- Delegates & DataSources. Required Methods for UIPickerView
    
    // Return number of columns (components)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    // Called by the picker view when it needs the title to use for a given row in a given component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  formulasArray[row].conversionString
    }
    
    // Capture the user's picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        rowSelected = row
        
        conversionString = formulasArray[row].conversionString

        assignunits()
        
        if conversionString == "fahrenheit to celsius" || conversionString == "celsius to fahrenheit" {
            posNeg.isHidden = false
        } else {
            posNeg.isHidden = true
            userInput.text = userInput.text!.replacingOccurrences(of: "-", with: "")
            posNeg.selectedSegmentIndex = 0
            
        }
        
        if userInput.text?.characters.count != 0 {
        calculateConversion()
        }
    }
    
    // MARK:- @IBActions
    // Executes if the user clicks on the "Convert" button
    @IBAction func convertButtonPressed(_ sender: UIButton) {
      
        calculateConversion()
        
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        
        calculateConversion()
    }
    
    @IBAction func posNegPressed(_ sender: UISegmentedControl) {
        
        if posNeg.selectedSegmentIndex == 1 {
            userInput.text = "-" + userInput.text!
        } else {
            userInput.text = userInput.text!.replacingOccurrences(of: "-", with: "")
    }
        if userInput.text == "-" {
            calculateConversion()
        }
        }
    
}

