//
//  DataWeightRecord.swift
//  DatabaseMigration
//
//  Copyright © 2019 NutritionFacts.org. All rights reserved.
//

import Foundation
import RealmSwift

class DataWeightRecord: Object {
    
    /// yyyyMMdd.typeKey e.g. 20190101.amKey
    @objc dynamic var id = "" 
    /// "yyyyMMdd"
    @objc dynamic var datestampKey = ""
    /// "typeKey" am or pm to identify which weight goal
    @objc dynamic var typeKey = ""
    // kilograms
    @objc dynamic var kg = 0.0     
    // time of day HH:mm 24-hour
    @objc dynamic var time = ""    
    
    // MARK: Class Methods
    
    static func id(date: Date, type: DataCountType) -> String {
        return "\(date.datestampKey).\(type.typeKey())"
    }
    
    static func idKeys(id: String) -> (datestampKey: String, typeKey: String) {
        let parts = id.components(separatedBy: ".")
        return (datestampKey: parts[0], typeKey: parts[1])
    }
    
    // MARK: - Init
    
    /// CSV Initialer.
    convenience init?(datestampKey: String, typeKey: String, kg: Double, time: String) {
        guard DataWeightType(typeKey: typeKey) != nil,
            Date(datestampKey: datestampKey) != nil else {
                return nil
        }
        
        self.init()
        self.datestampKey = datestampKey
        self.typeKey = typeKey
        self.kg = kg
        self.time = time // :NYI: unvalidated time.
        self.id = "\(self.datestampKey).\(self.typeKey)"
    }
    
    convenience init(date: Date, type: DataWeightType, kg: Double) {
        self.init()
        self.datestampKey = date.datestampKey
        self.typeKey = type.typeKey()
        self.kg = kg
        self.time = date.datestampHHmm
        self.id = "\(self.datestampKey).\(self.typeKey)"
    }
    
    // MARK: - Meta Information
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// properties to be indexed
    override class func indexedProperties() -> [String] {
        return ["datestampKey", "typeKey"]
    }
    
    // MARK: - Data Presentation Methods
    
}
