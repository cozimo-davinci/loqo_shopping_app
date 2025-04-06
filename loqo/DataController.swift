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
    
    // In DataController.swift

    init(){
        persistentContainer = NSPersistentContainer(name: "ProductModel")
        persistentContainer.loadPersistentStores{(description, error) in
            if let error = error {
                fatalError("Core Data store failed \(error.localizedDescription)")
            }

            // Check if the store is empty and populate if needed
            self.populateInitialData()
        }
    }

    func populateInitialData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            let existingProducts = try context.fetch(fetchRequest)
            if existingProducts.isEmpty {
                let initialProductsData: [ProductList] = [
                    ProductList(id: 1, title: "Pants", price: 82, description: "Stylish Pants", category: "Apparel", image: "hm1", quantity: 1),
                    ProductList(id: 2, title: "Dress", price: 70, description: "Brown Dress", category: "Apparel", image: "hm2", quantity: 1),
                    ProductList(id: 3, title: "Shirt", price: 129, description: "Black Shirt", category: "Apparel", image: "hm3", quantity: 1),
                    ProductList(id: 4, title: "T-shirt", price: 62, description: "T-shirt", category: "Footwear", image: "hm4", quantity: 1)
                ]

                for productData in initialProductsData {
                    let newProduct = Product(context: context)
                    newProduct.id = Int64(productData.id)
                    newProduct.title = productData.title
                    newProduct.price = productData.price
                    newProduct.desc = productData.description
                    newProduct.category = productData.category
                    newProduct.image = productData.image
                    newProduct.quantity = Int64(productData.quantity)
                }

                try context.save()
            }
        } catch {
            print("Error fetching or saving initial data: \(error)")
        }
    }
    
}
