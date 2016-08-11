# CS 442 Code Repository
-----------------------------------------------------------------------------
Machine Problem 1: A Simple Unit Converter
	This iOS project is based on iOS 9.3, Swift 2.2, and developed on Xcode 7.3.1 (7D1014).	All rights reserved.
	Created by: Xin Su <xsu11@hawk.iit.edu>

-----------------------------------------------------------------------------
File List:
	The main files are listed below:

	UnitConverter/
		AppDelegate.swift
		Constants.swift
		ConverterCalc.swift
		ViewController.swift
		Info.plist
		Base.lproj/
			LaunchScreen.storyboard
			Localizable.strings
			Main.storyboard
		en.lproj/
			LaunchScreen.storyboard
			Localizable.strings
			Main.storyboard
		es.lproj/
			LaunchScreen.storyboard
			Localizable.strings
			Main.storyboard
		zh-Hans.lproj/
			LaunchScreen.storyboard
			Localizable.strings
			Main.storyboard
	UnitConverter.xcodeproj
	README.md

-----------------------------------------------------------------------------
Installation Instruction:
	Use Xcode to open the project file "UnitConverter.xcodeproj", then run the app using the Simulator.

-----------------------------------------------------------------------------
Extra Credit:
	The four recommended extras listed on http://moss.cs.iit.edu/cs442/mp1.html are all included. Becides those, there are some additional functions:
	1. The textField is extended to let user input float number. If the user input dot(.) when the content is empty, the textField will consider this as the user is inputing an number that start with "0." by adding this to the content;
	2. The textField is extended to let user input delete backward. User can delete the content by tapping the delete button on the keyboard.

-----------------------------------------------------------------------------
