//
//  FilterTableViewCell.swift
//  Filters
//
//  Created by Mia Liu on 6/27/16.
//  Copyright © 2016 Mia Liu. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var arrowUp: Bool = true // 1 downToUp, -1 upToDown
    var crimeID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setStates(buttonUp up: Bool, switchState on: Bool) {
        setButton(up)
        setSwitch(on)
    }
    
    func setButton(up: Bool) {
        arrowUp = up
        btn.setTitle(up ? "⬆︎":  "⬇︎", forState: .Normal)
    }
    
    func setSwitch(on: Bool) {
        switcher.setOn(on, animated: false)
        btn.enabled = on
    }
    
    func turnSwitcher() -> Bool {
        btn.enabled = switcher.on
        return true
    }
    
    func turnBtn() -> Bool {
        if !switcher.on {
            return false
        }        
        setButton(!arrowUp)
        return true
    }
    
}
