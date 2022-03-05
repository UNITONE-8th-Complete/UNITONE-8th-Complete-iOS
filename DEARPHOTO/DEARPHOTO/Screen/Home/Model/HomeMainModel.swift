//
//  HomeMainModel.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import UIKit

struct HomeMainModel: Decodable {
    var id: Int?
    var title: String?
    var image: String?
    var postCount: Int?
    var users: [ImageURL]?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case image = "image"
        case postCount = "post_count"
        case users = "users"
        case createdAt = "created_at"
    }
}

struct ImageURL: Decodable {
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

extension HomeMainModel {
    var albumImage: UIImage? {
        var albumImage = UIImage()
        guard let albumImageURL = image else { return nil }
    
        let imageData = try? Data(contentsOf: URL(string: albumImageURL)!)
        albumImage = UIImage(data: imageData ?? Data()) ?? UIImage()
        
        return albumImage
    }
    
    var userImages: [UIImage]? {
        var userImages: [UIImage] = []
        guard let userImageURL = users else { return nil }
        
        userImageURL.forEach {
            let imageData = try? Data(contentsOf: URL(string: $0.imageURL!)!)
            userImages.append(UIImage(data: imageData!) ?? UIImage())
        }
        
        return userImages
    }
}
