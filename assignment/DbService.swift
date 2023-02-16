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
//        print(models)
        return models
        
    }
    
    func createItem(title:String,id:String,width:Int16,height:Int16,url:URL){
        let newItem = FavoriteItems(context: context)
        newItem.title = title
        newItem.date=Date()
        newItem.url=url
        newItem.width=width
        newItem.height=height
        newItem.id=id
        do{
            try context.save()
            getAllItem()
        }catch{
            
        }
    }
    
    func deleteItem(item:FavoriteItems){
        context.delete(item)
        getAllItem()
        
        do{
            try context.save()
        }catch{
            
        }
    }
    
    

}
