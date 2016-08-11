# CS 442 Code Repository
-----------------------------------------------------------------------------
Machine Problem 2: An Improved Unit Converter
	This iOS project is based on iOS 9.3, Swift 2.2, and developed on Xcode 7.3.1 (7D1014).	All rights reserved.
	Created by: Xin Su <xsu11@hawk.iit.edu>

-----------------------------------------------------------------------------
File List:
	The main files are listed below:

	ImprovedUnitConverter/
		AppDelegate.swift
		Constants.swift
		ConverterCalc.swift
		MasterViewController.swift
		DetailViewController.swift
		Info.plist
		InitialSettings.plist
		UnitConverterTableViewCell.swift
		Base.lproj/
			LaunchScreen.storyboard
			Main.storyboard
	ImprovedUnitConverter.xcodeproj
	README.md

-----------------------------------------------------------------------------
Installation Instruction:
	Use Xcode to open the project file "ImprovedUnitConverter.xcodeproj", then run the app using the Simulator.

-----------------------------------------------------------------------------
Extra Credit:
	The first recommended extra (Insta Convert) listed on http://moss.cs.iit.edu/cs442/mp1.html is implemented. Becides those, there are some additional functions:
	1. The textField is extended to let user input float number. If the user input dot(.) when the content is empty, the textField will consider this as the user is inputing an number that start with "0." by adding this to the content;
	2. The textField is extended to let user input delete backward. User can delete the content by tapping the delete button on the keyboard.

-----------------------------------------------------------------------------
