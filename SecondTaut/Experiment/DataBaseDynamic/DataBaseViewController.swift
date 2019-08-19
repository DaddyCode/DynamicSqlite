//
//  DataBaseViewController.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 19/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import SQLite


class DataBaseViewController: UIViewController {

    var Localdatabase: Connection!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnMessageAddInDataBase(_ sender: Any) {
        
//        let TEMPDIct = ["Message":"hi pawan","Type":"text","new":"lastTry","again":"again"]
//        self.StartSqlite(MessageDict: TEMPDIct as NSDictionary)
//
    
        
      self.GetValueFromSqlite()
        
    }
    
    
    func StartSqlite( MessageDict : NSDictionary){
        //sqliteConenct
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("SecondTaut").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            Localdatabase = database
            self.CreateTable(messageData: MessageDict)
            
        } catch {
             print(error)
        }
    }
    
    
    
    func CreateTable(messageData : NSDictionary ){
        
        //Create Table if available already then get Value
        let TableName = "ChatMessage"
        let usersTableForNow = Table(TableName)
        
        let createTable = usersTableForNow.create { (table) in
            let AllKEYS : NSArray  = messageData.allKeys as NSArray
            for key in AllKEYS {
                table.column(Expression<String>(key as! String))
            }
        }
        do {
            //Create Table
            print("Table Create")
            try Localdatabase.run(createTable)
        } catch {
            //GET Table
            print("Table Already Exist")
            self.AddValueInSqliteLocalDataBase(MessageData: messageData)
      
        }
        
    }
    

    
    func AddValueInSqliteLocalDataBase(MessageData : NSDictionary){
  
        let TableName : String = "ChatMessage"
        
        var KeyStringCreate = "("
        var ValueStringCcreate = "("
        
        for Key in MessageData.allKeys{
            let KeyGot = Key as! String
            KeyStringCreate = KeyStringCreate + KeyGot + ","
            let Value = MessageData[KeyGot] as! String
             ValueStringCcreate = ValueStringCcreate + "'" + Value + "'" + ","
        }
        KeyStringCreate = String(KeyStringCreate.dropLast()) + ")"
        ValueStringCcreate = String(ValueStringCcreate.dropLast()) + ");"
     
        
       let FinalQueryForINsert = "INSERT INTO " + TableName + " " + KeyStringCreate + " VALUES " + ValueStringCcreate
        print(FinalQueryForINsert)
        
        do {
            try Localdatabase.run(FinalQueryForINsert)
        } catch {
            print(error.localizedDescription)
            self.AddColoum(Data: MessageData)
        }

        

        
    }


    
    
    func AddColoum(Data : NSDictionary){
        let TableName = "ChatMessage"
        let usersTableForNow = Table(TableName)
        let ALLKEYS = Data.allKeys as NSArray
        for key in ALLKEYS {
            let RowinSert = Expression<String?>(key as! String)
            do {
                try Localdatabase.run(usersTableForNow.addColumn(RowinSert))
                print("Added repeatIntervals")
            } catch {
                print(error)
            }
            
        }
        //NewRow insert now add data
        self.AddValueInSqliteLocalDataBase(MessageData: Data)
   
    }

    
    
    func GetValueFromSqlite(){
        let FinalQueryForINsert = "SHOW COLUMNS FROM ChatMessage"
        print(FinalQueryForINsert)
 
        do {
            try Localdatabase.run(FinalQueryForINsert)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    ////////////
}
