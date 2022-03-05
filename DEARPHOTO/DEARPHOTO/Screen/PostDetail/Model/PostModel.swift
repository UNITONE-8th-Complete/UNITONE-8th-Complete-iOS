//
//  PostModel.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit
import Kingfisher

struct PostModel: Decodable {
    var id: Int?
    var author_name: String?
    var author_image_url: String?
    var title: String?
    var content: String?
    var images: [String]?
    var like_count: Int?
    var comment_count: Int?
    var comments: [CommentModel]?
    var created_at: String?
    
    var postImages: [UIImage]? {
        var postImages: [UIImage] = []
        guard let postImgURL = images else { return nil }

        postImgURL.forEach { imageURL in
            let encodedStr = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedStr)!
            
            let data = try? Data(contentsOf: url)
            postImages.append(UIImage(data: data ?? Data()) ?? UIImage())
        }
        
        return postImages
    }
}
