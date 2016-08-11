//
//  SQLiteDBManager.swift
//  CrimeDataInChicago
//
//  Created by xinsu on 6/26/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

class SQLiteDBManager {
    
    var DB: COpaquePointer = nil
    
    func openSQLiteDB(dbFilePath: String) -> Bool {
        if (sqlite3_open(dbFilePath, &DB) == SQLITE_OK) {
            print("SQLite3 db is opened.")
            return true
        }
        return false
    }
    
    func closeSQLiteDB() -> Bool{
        if (sqlite3_close(DB) == SQLITE_OK) {
            print("SQLite3 db is closed.")
            return true
        }
        return false
    }
    
    func query(statement: String) -> Array<Array<String>> {
        var statementPointer: COpaquePointer = nil
        var results = Array<Array<String>>()
        if sqlite3_prepare_v2(DB, statement, -1, &statementPointer, nil) == SQLITE_OK {
            var j = 0
            while sqlite3_step(statementPointer) == SQLITE_ROW {
                results.append(Array<String>())
                for i in 0 ..< sqlite3_column_count(statementPointer) {
                    let queryResultCol1 = sqlite3_column_text(statementPointer, i)
                    if let text = String.fromCString(UnsafePointer<CChar>(queryResultCol1)) {
                        results[results.count - 1].append(text)
                    } else {
                        results[results.count - 1].append("")
                    }
                }
                j += 1
            }
        }
        sqlite3_finalize(statementPointer)
        return results
    }
    
}