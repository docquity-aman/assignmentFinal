//
//  DbService.swift
//  assignment
//
//  Created by Aman Verma on 15/02/23.
//

import Foundation
import CoreData
import UIKit

class DbService{
    static let shareInstance = DbService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models=[FavoriteItems]()
    
    func getAllItem()->[FavoriteItems]{
        do{
            models = try context.fetch(FavoriteItems.fetchRequest()) 
            //            print("Models: ",models)
            
        }catch{
            //error
            print ("Data Not Found")
        }
        return models
        
    }
    
    func createItem(title:String,id:String,width:Int16,height:Int16,url:URL){
        let fetchRequest: NSFetchRequest<FavoriteItems>
                fetchRequest = FavoriteItems.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "id = %@",id
                )

      
        do{
            let objects = try context.fetch(fetchRequest)
            if(!objects.isEmpty){
                print("found : ",objects)
                                return
            }
            else{
                let newItem = FavoriteItems(context: context)
                newItem.title = title
                newItem.date=Date()
                newItem.url=url
                newItem.width=width
                newItem.height=height
                newItem.id=id
            }
            try context.save()
        }catch{
            print("Saving Error")
        }
    }
    
    func deleteItem(item:FavoriteItems){
        context.delete(item)
        do{
            try context.save()
        }catch{
            
        }
    }
    
    
    
}
