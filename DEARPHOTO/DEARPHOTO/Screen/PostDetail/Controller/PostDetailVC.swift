//
//  PostDetailVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit
import RxSwift
import RxDataSources
import Alamofire
import SwiftKeychainWrapper

class PostDetailVC: UIViewController {
    @IBOutlet weak var commentListTV: UITableView!
    @IBOutlet weak var chatInputView: ChatInputView!
    
    let apiSession = APISession()
    let bag = DisposeBag()
    var post = PostModel()
    var boardId: Int?
    var isScrolled = false
    let refreshControl = UIRefreshControl()
    
    let dummyComment = [
        CommentModel(commentId: 0,
                     name: "mylettergood",
                     profile_image: "",
                     comment_text: "와 이게 언제적이야~너무 귀엽다",
                     created_at: "3시간 전",
                     canEdit: false,
                     writerOrNot: false),
        CommentModel(commentId: 0,
                     name: "Ddfjfl",
                     profile_image: "",
                     comment_text: "기억난다~^^ 그땐 키가 나보다 작았는데 말이야",
                     created_at: "3시간 전",
                     canEdit: false,
                     writerOrNot: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
//        setCommentListTV()
        getPost()
    }
}

extension PostDetailVC {
    // MARK: - Configure
    func configureNavigationMenuButton() {
        let menuButton = UIBarButtonItem()
        menuButton.image = UIImage(named: "Menu_Horizontal")
        
        navigationItem.rightBarButtonItem = menuButton
    }

    func register(){
        commentListTV.register(UINib(nibName: Identifiers.commentTVC, bundle: nil), forCellReuseIdentifier: Identifiers.commentTVC)
        commentListTV.register(PostContentTableViewHeader.self, forHeaderFooterViewReuseIdentifier: Identifiers.postContentTableViewHeader)
    }
    
    func setCommentListTV() {
        commentListTV.dataSource = self
        commentListTV.delegate = self
        commentListTV.backgroundColor = .white
        commentListTV.separatorStyle = .none
    }
    
    
    // MARK: - Network
    private func getPost() {
        let baseURL = "http://13.124.131.113:8000"
        guard let url = URL(string: baseURL + "/albums/3/post/6") else { return }
        let resource = urlResource<PostModel>(url: url)

        apiSession.getRequest(with: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let post):
                    dump(post)
                    self.post = post
                    DispatchQueue.main.async {
                        self.setCommentListTV()
                    }
                case .failure:
                    break
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDelegate
extension PostDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.postContentTableViewHeader) as? PostContentTableViewHeader else { return nil }
        headerView.configureContents(with: post)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commentListTV.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (post.comments?.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentTitleTVC", for: indexPath)

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentTVC, for: indexPath) as? CommentTVC else { return UITableViewCell() }

            cell.configureCell(post.comments?[indexPath.row - 1] ?? CommentModel(), 0)
            return cell
        }
    }
}
