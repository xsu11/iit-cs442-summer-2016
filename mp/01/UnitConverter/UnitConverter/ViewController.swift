//
//  ViewController.swift
//  UnitConverter
//
//  Created by Xin Su <xsu11@hawk.iit.edu> on 6/9/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var unitSegments: UISegmentedControl!
    
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var upperLabel: UILabel!
    
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var convertArrow: UIButton!
    
    @IBOutlet weak var lowerTextField: UITextField!
    @IBOutlet weak var lowerLabel: UILabel!
    
    var converterCalc = ConverterCalc() // The Model, all calculation logic functions are located here
    var constants = Constants()         // Constants for this app
    var convertDirection = -1           // Used to show the arrow's direction: 1: Up; -1: Down
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set titles and texts of the objects
        unitSegments.setTitle(constants.temperatureSegment, forSegmentAtIndex: 0)
        unitSegments.setTitle(constants.distanceSegment, forSegmentAtIndex: 1)
        unitSegments.setTitle(constants.volumeSegment, forSegmentAtIndex: 2)
        upperLabel.text = constants.temperatureUpperUnitLabel
        lowerLabel.text = constants.temperatureLowerUnitLabel
        convertButton.setTitle(constants.convertButtonLabel, forState: .Normal)
        convertArrow.setTitle(constants.downDirection, forState: .Normal)
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      textFieldShouldReturn(textField: UITextField) -> Bool
     *
     *  Function Decsription:
     *      Manipulate textField return input.
     *      If the textField uses Decimal pad, then this function is not in use.
     *
     *  Parameters:
     *      textField: UITextField : the operated textfield
     *
     *  Return:
     *      Bool : the result whether the return operation succeeds.
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return convert()
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      textField(textField: UITextField,
     *                shouldChangeCharactersInRange range: NSRange,
     *                replacementString string: String) -> Bool
     *
     *  Function Decsription:
     *      Manipulate textField return input.
     *
     *  Parameters:
     *      textField: UITextField : the operated textfield
     *      shouldChangeCharactersInRange range: NSRange : text range
     *      replacementString string: String :input string
     *
     *  Return:
     *      Bool : the result whether the input operation succeeds.
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
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
    
    /****************************************************************************
     *
     *  Function Name:
     *      textFieldDidBeginEditing(textField: UITextField)
     *
     *  Function Decsription:
     *      Manipulate textField when moving cursor to it (the textField is tapped).
     *
     *  Parameters:
     *      textField: UITextField : the operated textfield
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    func textFieldDidBeginEditing(textField: UITextField) {
        // When the cursor is in the upperTextField and convert direction is up
        // or the cursor is in the lowerTextField and convert direction is down,
        // change the convert direction.
        if ((textField === upperTextField && convertDirection == 1) || (textField === lowerTextField && convertDirection == -1)) {
            changeDirection()
        }
        
        // If the cursor is in the textField and it contains content, do the convertion.
        if (textField.hasText()) {
            convert()
        }
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      changeDirection()
     *
     *  Function Decsription:
     *      Change the convertArrow's direction
     *
     *  Parameters:
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    func changeDirection() {
        convertDirection *= -1
        
        if (convertDirection == -1) {
            convertArrow.setTitle(constants.downDirection, forState: .Normal)
        } else if (convertDirection == 1) {
            convertArrow.setTitle(constants.upDirection, forState: .Normal)
        }
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      hasDot(string: String) -> Bool
     *
     *  Function Decsription:
     *      Indicate whether the input string contains dot(.).
     *
     *  Parameters:
     *      string: String : input string
     *
     *  Return:
     *      Bool : the result whether the input string contains dot(.)
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    func hasDot(string: String) -> Bool {
        return string.containsString(".") ? true : false
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      convert() -> Bool
     *
     *  Function Decsription:
     *      Process the unit convertion.
     *
     *  Parameters:
     *
     *  Return:
     *      Bool : the result whether the unit convertion succeeds
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    func convert() -> Bool {
        // unitSegments.selectedSegmentIndex:
        // 0: Temperature
        // 1: Distance
        // 2: Volume
        
        // convertDdirection:
        // 1: Up
        // -1: Down
        
        // Use this formular: unitSegments.selectedSegmentIndex + 1) * convertDirection
        // to chage result to {-3, -2, -1, 1, 2, 3}.
        // If the result is negative, then the convertion direction is down,
        // else if it is positive, then the direction is up.
        // The abs(result) is the same Segment Index listed above.
        switch (unitSegments.selectedSegmentIndex + 1) * convertDirection {
        case -1:
            if let f = Double(upperTextField.text!) {
                lowerTextField.text = String(format:"%.2f", converterCalc.fahrToCelsius(f))
            }
            break
        case -2:
            if let m = Double(upperTextField.text!) {
                lowerTextField.text = String(format:"%.2f", converterCalc.mileToKilometer(m))
            }
            break
        case -3:
            if let g = Double(upperTextField.text!) {
                lowerTextField.text = String(format:"%.2f", converterCalc.gallonToLiter(g))
            }
            break
        case 1:
            if let c = Double(lowerTextField.text!) {
                upperTextField.text = String(format:"%.2f", converterCalc.celsiusToFahr(c))
            }
            break
        case 2:
            if let k = Double(lowerTextField.text!) {
                upperTextField.text = String(format:"%.2f", converterCalc.kilometerToMile(k))
            }
            break
        case 3:
            if let l = Double(lowerTextField.text!) {
                upperTextField.text = String(format:"%.2f", converterCalc.literToGallon(l))
            }
            break
        default:
            print("@IBAction func convert(sender: AnyObject): Wrong convert option.")
            return false
        }
        return true
    }

    /****************************************************************************
     *
     *  Function Name:
     *      @IBAction func changeUnitSegment(sender: UISegmentedControl)
     *
     *  Function Decsription:
     *      This is an action when the Unit Segment is tapped
     *
     *  Parameters:
     *      sender: UISegmentedControl : the owner of this action
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    @IBAction func changeUnitSegment(sender: UISegmentedControl) {
        // Set texts for the segments by the index,
        switch unitSegments.selectedSegmentIndex {
        case 0:
            upperLabel.text = constants.temperatureUpperUnitLabel
            lowerLabel.text = constants.temperatureLowerUnitLabel
            break
        case 1:
            upperLabel.text = constants.distanceUpperUnitLabel
            lowerLabel.text = constants.distanceLowerUnitLabel
            break
        case 2:
            upperLabel.text = constants.volumeUpperUnitLabel
            lowerLabel.text = constants.volumeLowerUnitLabel
            break
        default:
            print("@IBAction func changeUnitSegment(sender: UISegmentedControl): Wrong convert option.")
            return
        }
        
        // then convert the unit.
        convert()
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      @IBAction func convertUnit(sender: UIButton)
     *
     *  Function Decsription:
     *      This is an action when the Convert button is tapped
     *
     *  Parameters:
     *      sender: UIButton : the owner of this action
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    @IBAction func convertUnit(sender: UIButton) {
        convert()
    }

    /****************************************************************************
     *
     *  Function Name:
     *      hasDot(string: String) -> Bool
     *
     *  Function Decsription:
     *      This is an action when the Arrow button is tapped
     *
     *  Parameters:
     *      sender: UIButton : the owner of this action
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    @IBAction func changeConvertDirection(sender: UIButton) {
        changeDirection()
    }

    /****************************************************************************
     *
     *  Function Name:
     *      @IBAction func dismissKeyBoard(sender: UITapGestureRecognizer)
     *
     *  Function Decsription:
     *      This is an action when the tap is proceeded to dismiss the keyboard
     *
     *  Parameters:
     *      sender: UITapGestureRecognizer : the owner of this action
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    @IBAction func dismissKeyBoard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /****************************************************************************
     *
     *  Function Name:
     *      @IBAction func autoConvert(sender: UITextField)
     *
     *  Function Decsription:
     *      This is an action when the text in the textField begins to change
     *
     *  Parameters:
     *      sender: UITextField : the owner of this action
     *
     *  Return:
     *
     *  History:
     *      Name                            Date            Description
     *      ---------------------------------------------------------------------
     *      Xin Su <xsu11@hawk.iit.edu>     2016-06-10      Created.
     *
     ****************************************************************************/
    @IBAction func autoConvert(sender: UITextField) {
        convert()
    }
    
}

