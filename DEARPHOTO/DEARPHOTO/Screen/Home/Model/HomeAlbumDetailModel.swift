//
//  HomeAlbumDetailModel.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/06.
//

import UIKit

struct HomeAlbumDetailModel: Decodable {
    var id: Int?
    var authorName: String?
    var authorImageURL: String?
    var title: String?
    var images: [String]?
    var likeCount: Int?
    var commentCount: Int?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case authorName = "author_name"
        case authorImageURL = "author_image_url"
        case title = "title"
        case images = "images"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case createdAt = "created_at"
    }
}

extension HomeAlbumDetailModel {
    var profileImage: UIImage? {
        var profileImage = UIImage()
        guard let profileImageURL = authorImageURL else { return nil }
    
        let imageData = try? Data(contentsOf: URL(string: profileImageURL)!)
        profileImage = UIImage(data: imageData ?? Data()) ?? UIImage()
        
        return profileImage
    }
}
