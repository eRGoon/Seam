//    Preference.swift
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Nofel Mahmood ( https://twitter.com/NofelMahmood )
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation
import CoreData

class Preference: NSManagedObject {
  
  @NSManaged var key: String?
  @NSManaged var value: String?
  
  struct Default {
    static let zoneName = "zoneName"
    static let zoneSubscriptionName = "zoneSubscriptionName"
  }
  // MARK: Entity

  struct Entity {
    static let name = "Seam_Preference"
    static var entityDescription: NSEntityDescription {
      let entityDescription = NSEntityDescription()
      entityDescription.name = name
      entityDescription.properties.append(Properties.Key.attributeDescription)
      entityDescription.properties.append(Properties.Value.attributeDescription)
      entityDescription.managedObjectClassName = "Seam.Preference"
      return entityDescription
    }
  }
  
  // MARK: Properties
  
  struct Properties {
    struct Key {
      static let name = "key"
      static var attributeDescription: NSAttributeDescription {
        let attributeDescription = NSAttributeDescription()
        attributeDescription.name = name
        attributeDescription.attributeType = .StringAttributeType
        attributeDescription.optional = false
        return attributeDescription
      }
    }
    struct Value {
      static let name = "value"
      static var attributeDescription: NSAttributeDescription {
        let attributeDescription = NSAttributeDescription()
        attributeDescription.name = name
        attributeDescription.attributeType = .StringAttributeType
        attributeDescription.optional = false
        return attributeDescription
      }
    }
  }
  
  // MARK: Manager
  
  class Manager {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
      self.context = context
    }
    
    func saveZoneName(name: String) {
      let preference = NSEntityDescription.insertNewObjectForEntityForName(Entity.name, inManagedObjectContext: context) as! Preference
      preference.key = Default.zoneName
      preference.value = name
      try! context.save()
    }
    
    func saveZoneSubscriptionName(name: String) {
      let preference = NSEntityDescription.insertNewObjectForEntityForName(Entity.name, inManagedObjectContext: context) as! Preference
      preference.key = Default.zoneSubscriptionName
      preference.value = name
      try! context.save()
    }
    
    func zoneName() throws -> String? {
      let fetchRequest = NSFetchRequest(entityName: Entity.name)
      fetchRequest.predicate = NSPredicate.preferenceZoneNamePredicate
      return (try context.executeFetchRequest(fetchRequest).first as? Preference)?.value
    }
    
    func zoneSubscriptionName() throws -> String? {
      let fetchRequest = NSFetchRequest(entityName: Entity.name)
      fetchRequest.predicate = NSPredicate.preferenceZoneSubscriptionNamePredicate
      return (try context.executeFetchRequest(fetchRequest).first as? Preference)?.value
    }
  }
}