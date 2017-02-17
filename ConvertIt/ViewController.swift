//
//  ViewController.swift
//  $125 Million App
//
//  Created by CSOM on 1/28/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    
    
    
    var formulasArray = ["miles to kilometers",
                         "kilometers to miles",
                         "feet to meters",
                         "yards to meters",
                         "meters to feet",
                         "meters to yards"]
    
    var toUnits = ""
    var fromUnits = ""
    var conversionString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        
        conversionString = formulasArray[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        //perform the four-step process to create alert, create an action, assign an action to the alert, and press the alert.
        let alertController = UIAlertController(title: "Entry Error", message: "Please enter a valid number. Not an empty string, no commas, symbols, or non-numeric characters", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func calculateConversion() {
        
        var inputValue = 0.0
        var outputValue = 0.0
         var outputString = ""
        
        if let inputValue = Double(userInput.text!) {
            
            switch conversionString {
            case "miles to kilometers" :
                outputValue = inputValue / 0.62137
            case "kilometers to miles" :
                outputValue = inputValue * 0.62137
            case "feet to meters" :
                outputValue = inputValue / 3.2808
            case "yards to meters" :
                outputValue = inputValue / 1.0936
            case "meters to feet" :
                outputValue = inputValue * 3.2808
            case  "meters to yards" :
                outputValue = inputValue * 1.0936
            default:
                showAlert()
            }
            
        } else {
            showAlert()
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
        return  formulasArray[row]
    }
    
    // Capture the user's picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        conversionString = formulasArray[row]
        let unitsArray = formulasArray[row].components(separatedBy: " to ")
        
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        //  resultsLabel.text = toUnits
        calculateConversion()
    }
    
    // MARK:- @IBActions
    // Executes if the user clicks on the "Convert" button
    @IBAction func convertButtonPressed(_ sender: UIButton) {
      
        calculateConversion()
        
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        
        calculateConversion()
    }
    
    
}

