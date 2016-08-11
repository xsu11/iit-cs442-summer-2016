# CS 442 Code Repository
-----------------------------------------------------------------------------
Machine Problem 3&4 / Project: 2015 Crime Data in Chicago

	This iOS project is based on:
		iOS 9.3, Swift 2.2, and developed on Xcode 7.3.1 (7D1014).
		SQLite 3.13.0
		Python 2.7
	All rights reserved.

	Created by:
		Xin Su <xsu11@hawk.iit.edu>
		Man LIu <mliu41@hawk.iit.edu>

-----------------------------------------------------------------------------
File List:

	The main files are listed below:

	data/
		Crimes_-_2015.csv
		crime.csv
		crime_loc.csv
		comm_area_geo.csv
		comm_area.csv
		fbi_code.csv
		iucr.csv
		initialSettings.plist
		process_data.ipynb
		crime_db.sqlite3
		
	CrimeDataInChicago/
		Assets.xcassets
		Base.lproj/
			LaunchScreen.storyboard
			Main.storyboard
		AppDelegate.swift
		TabBarViewController.swift
		FirstViewController.swift
		MasterTableViewController.swift
		DetailTableViewController.swift
		DetailMapViewController.swift
		SQLiteDBManager.swift
		FilterData.swift
		FilterTableViewCell.swift
		bridging-header.h
		Info.plist
		initialSettings.plist
		CrimeDataInChicago.xcdatamodeld
		CommArea+CoreDataProperties.swift
		CommArea.swift
		CommAreaGeo+CoreDataProperties.swift
		CommAreaGeo.swift
		Crime+CoreDataProperties.swift
		Crime.swift
		CrimeLoc+CoreDataProperties.swift
		CrimeLoc.swift
		FBICode+CoreDataProperties.swift
		FBICode.swift
		IUCR+CoreDataProperties.swift
		IUCR.swift
	CrimeDataInChicago.xcodeproj
	README.md

-----------------------------------------------------------------------------
Installation Instruction:

	1. Copy "crime_db.sqlite3" and "initialSettings.plist" from the data directory into the Documents directory of the product in your computer. You may comment this codes in AppDelegate.swift file and then run the project to get the directory in the command line window (remember t ouncomment after getting the directory!):

//        let dbFilePath = getDBFilePath()
//        let didLoadData = getDidLoadData()
//        if didLoadData == 0 {
//            loadData(dbFilePath)
//            setDidLoadData(1)
//        }

	2. Use Xcode to open the project file "CrimeDataInChicago.xcodeproj". The first time you run the app may take a long time (maybe 60 seconds?), for it imports data from SQLite into the app's CoreData. After the app is launched, you will see a screen with two tabs:
	- The first tab, which is shown defaultly, is the crime area map using different colors to fill up different areas based on the crimes count.
	- The second tab is the "Choose Filter" tab, where you can choose filter to see more details. We provide two filters now: Community Area and Crime Type. After you choose the filter, you will see the list of results of the crimes. Then if you choose any crime. it will show you the location where the crime happened.

-----------------------------------------------------------------------------
Implementation:

	1. Data source: we choose to use the data in Crime_-_2015.csv downloaded from the Citi of Chiago website. Then we split the data into six entities to build the data model. You can view the ER model in the project model view.
	- crime.csv: crime data, with community area info, crime type (iucr) info and fbi info. This entity has 261922 tuples.
	- crime_loc.csv: crime location data, with coordinate info (latitude and longitude). This entity has 261922 tuples.
	- comm_area.csv: community area data, with community area number and name info. This entity has 77 tuples.
	- comm_area_geo.csv: community area geo data, with area coordinates info. This entity has 52065 tuples.
	- fbi_code.csv: fbi data. This entity has 26 tuples.
	- iucr,csv: crime type data.This entity has 401 tuples.

	2. Import data: first we use Python to split the data from the original source file into six different entity csv files. Second we use SQLite to import the data from csv files. Then we import the tables' data from SQLite into the app's CoreData. We are able to directly import data from csv files into CoreData. The reason we didn't do this is that using sqlite is simpler for us to manipulate data in a bunch and do some validation.

	3. Then we create the app, create the model, import data, and then draw the community area range in the map. We finaly create a simple funtion to filter the crime.

	4. When we import the data from SQLlite into the CoreData, as we only want to import the data once at the first time the app is launched, we choose the use the plist to store a flag . After importing we would change the flag so that next the app is launched it won't import the data again.
-----------------------------------------------------------------------------
