//
//  DetailViewController.swift
//  ImprovedUnitConverter
//
//  Created by xinsu on 6/19/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Global variables
    
    var convertCalc = ConverterCalc()
    var constants = Constants()
    var detailObjects = [AnyObject]()
    var detailTitle: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var currentTextField: UITextField?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailTitle {
            self.title = detail.description
        }
    }
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // Add + button on the rightBar.
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        convertCalc.basicType = constants.basicTypes![self.detailTitle as! String]!
        convertCalc.coefficients = constants.initialSettings![detailTitle as! String] as! [String:[Double]]
    }
    
    func insertNewObject(sender: AnyObject) {
        // TODO: - Insert new Object.
    }
    
    func convertAll(sender: AnyObject) {
        if let text = self.currentTextField?.text {
            if (text != "") {
                convertUnit(self.currentTextField!)
                self.currentTextField!.text = String(format: "%.3f", Double(text)!)
                self.currentTextField!.resignFirstResponder()
            }
        }
    }
    
    func convertUnit(textField: UITextField) -> Bool {
        let currentCell = textField.superview!.superview as! UnitConverterTableViewCell
        let current = Double(currentCell.textField.text!)!
        let currentLabelContent = currentCell.label.text!
        
        for i in 0 ..< self.tableView.numberOfSections {
            for j in 0 ..< self.tableView.numberOfRowsInSection(i) {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: j, inSection: i)) as! UnitConverterTableViewCell
                if cell !== currentCell {
                    let labelContent = cell.label.text! as String
                    let base = convertCalc.reverse(current, coefficients: convertCalc.coefficients[currentLabelContent]!)
                    let newValue = convertCalc.convert(base, coefficients: convertCalc.coefficients[labelContent]!)
                    cell.textField.text = String(format:"%.3f", newValue)
                }
            }
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UnitConverterTableViewCell
        
        let labelContent = detailObjects[indexPath.row] as! String // This is also the key of to textFieldContents
        
        // Set label content
        cell!.label.text = labelContent
        
        // Set textField content
        var base: Double = 0.0
        if cell!.textField.text == "" {
            base = 100.0
        } else {
            base = convertCalc.reverse(Double(cell!.textField.text!)!, coefficients: convertCalc.coefficients[labelContent]!)
        }
        cell!.textField.text = String(format:"%.3f", convertCalc.convert(base, coefficients: convertCalc.coefficients[labelContent]!))
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    // MARK: - Text Field
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return convertUnit(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // delete backward
        if (range.location >= 0 && range.length >= 1 && string.isEmpty) {
            return true
        }
        
        switch string {
        case "0":
            // if the current text is "0", then prohibit to enter 0 again by returning false
            if (textField.text == "0") {
                return false
            }
            
            // break to proceed to return true
            break
        case "1", "2", "3", "4", "5", "6", "7", "8", "9":
            // if the current text is "0", then clear it
            if (textField.text == "0") {
                textField.text = ""
            }
            
            // break to proceed to return true
            break
        case ".":
            // if the current text contains ".", prohibit to enter "." again by returning false
            // else if the text is empty, add "0" to it before it enters "."
            if (hasDot(textField.text!)) {
                return false
            } else if (!textField.hasText()) {
                textField.text = "0"
            }
            
            // break to proceed to return true
            break
        default:
            return false
        }
        
        // return true to proceed the input
        return true
    }

    func hasDot(string: String) -> Bool {
        return string.containsString(".") ? true : false
    }
    
    // MARK: - Actions
    
    @IBAction func autoConvert(sender: UITextField) {
        if (sender.text != "") {
            convertUnit(sender)
        }
    }
    
    @IBAction func editingDidBegin(sender: UITextField) {
        self.currentTextField = sender
        self.currentTextField?.text = ""
        
        // Add + button on the rightBar.
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(convertAll(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @IBAction func editingDidEnd(sender: UITextField) {
        self.view.endEditing(true)
    }

}

