import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistanteContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DejavooNotesApp")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistanteContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                debugPrint(error)
            }
        }
    }
}

