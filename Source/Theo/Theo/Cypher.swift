//
//  Cypher.swift
//  Theo
//
//  Created by Cory D. Wiles on 10/7/14.
//  Copyright (c) 2014 Theo. All rights reserved.
//

import Foundation

let TheoCypherColumns: String = "columns"
let TheoCypherData: String    = "data"

open struct CypherMeta: CustomStringConvertible {
    
    let columns: Array<String>
    let data: Array<AnyObject>
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        self.columns = dictionary[TheoCypherColumns] as! Array
        self.data    = dictionary[TheoCypherData]    as! Array
    }
    
    open var description: String {
        return "Columns: \(columns), data \(data)"
    }
}

open class Cypher {

    var meta: CypherMeta?
    open fileprivate(set) var data: Array<Dictionary<String, AnyObject>> = Array<Dictionary<String, AnyObject>>()
    
    open required init(metaData: Dictionary<String, Array<AnyObject>>?) {
    
        if let dictionaryData: [String:[AnyObject]] = metaData {

            self.meta = CypherMeta(dictionary: dictionaryData as Dictionary<String, AnyObject>)
            
            if let metaForCypher: CypherMeta = self.meta {

                for arrayValues in metaForCypher.data as! Array<Array<AnyObject>> {

                    var cypherDictionary: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
                    
                    for (index, value) in arrayValues.enumerated() {

                        let cypherDictionaryKey: String = metaForCypher.columns[index]
                        
                        cypherDictionary[cypherDictionaryKey] = value
                    }
                    
                    self.data.append(cypherDictionary)
                }
            }
        }
    }
    
    open convenience init() {
        self.init(metaData: nil)
    }
}

// MARK: - Printable

extension Cypher: CustomStringConvertible {
    
    open var description: String {
        
        var returnString: String = ""
            
            for value: Dictionary<String, AnyObject> in self.data {
                
                for (returnStringKey, returnKeyValue) in value {
                    returnString += " \(returnStringKey): \(returnKeyValue)"
                }
            }
            
            if let meta: CypherMeta = self.meta {
                returnString += "meta description " + meta.description
            }
            
            return returnString
    }
}
