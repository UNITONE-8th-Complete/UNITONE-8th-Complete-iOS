//
//  PostContentTableViewHeader.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit
import Kingfisher

class PostContentTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var likeCnt: UILabel!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var createAt: UILabel!
    
    var postImages: [UIImage]?
    var post: PostModel?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setContentView()
        register()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentView()
        register()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setContentView() {
        guard let view = loadXibView(with: Identifiers.postContentTableViewHeader) else { return }
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setContent()
    }
    
    private func register() {
        imageCV.register(UINib(nibName: Identifiers.postImageCVC, bundle: nil), forCellWithReuseIdentifier: Identifiers.postImageCVC)
    }
    
    func setContent() {
        postContent.setLineBreakMode()
        imageCV.dataSource = self
        imageCV.delegate = self
        imageCV.showsHorizontalScrollIndicator = false
        imageCV.isPagingEnabled = true
        
        imageCV.layer.cornerRadius = 15
        
        if let flowLayout = imageCV.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func configureContents(with post: PostModel) {
        profileImg.kf.setImage(with: URL(string: post.author_image_url ?? ""),
                                          placeholder: UIImage(named: "Null_Comment"),
                                          options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                          ])
        userName.text = post.author_name
        createAt.text = post.created_at
        
        postContent.text = post.content

        postImages = post.postImages!
        
        likeCnt.text = String(describing: post.like_count ?? 0)
        commentCnt.text = String(describing: post.comment_count ?? 0)
    }
}

extension PostContentTableViewHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCV.dequeueReusableCell(withReuseIdentifier: Identifiers.postImageCVC, for: indexPath) as? PostImageCVC else { return UICollectionViewCell() }
        cell.imageView.image = postImages?[indexPath.row]
        
        return cell
    }
}

extension PostContentTableViewHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
