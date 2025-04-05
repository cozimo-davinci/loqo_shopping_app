//
//  DataController.swift
//  loqo
//
//  Created by Ramtin Abolfazli on 2025-04-05.
//
import Foundation
import CoreData

class DataController: ObservableObject {
    let persistentContainer: NSPersistentContainer
    
    init(){
        persistentContainer = NSPersistentContainer(name: "ProductModel")
        persistentContainer.loadPersistentStores{(description, error) in
            if let error = error {
                fatalError("Core Data store failed \(error.localizedDescription)")
            }
            
        }
    }
    
}
