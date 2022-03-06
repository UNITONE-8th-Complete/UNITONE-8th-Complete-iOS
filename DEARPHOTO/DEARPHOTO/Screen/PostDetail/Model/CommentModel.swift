//
//  CommentModel.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import Foundation

struct CommentModel: Decodable {
    var commentId: Int?
    var name: String?
    var profile_image: String?
    var comment_text: String?
    var created_at: String?
    var canEdit: Bool?
    var writerOrNot: Bool?
}
