//
//  GifModel.swift
//  assignment
//
//  Created by Aman Verma on 14/02/23.
//


import Foundation

struct GifModel:Codable{
    let data:[DataValue]
    let pagination:Pagination
    let meta:Meta
    
}
struct DataValue:Codable{
    var type, id: String
    var images: Images
    var title:String
   
    
}


struct Meta:Codable{
    var status: Int
    var msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }

}


struct Pagination:Codable{
    var totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}

struct Images:Codable{
    var downsizedMedium:DownSizeMedium
    
    enum CodingKeys: String, CodingKey {
        case downsizedMedium = "downsized_medium"
    }
}
struct DownSizeMedium:Codable{
    var height, width, size: String
        var url: String
}
