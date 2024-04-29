//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Kailash Bora on 26/04/24.
//

import UIKit

protocol SearchResultViewCellDelegate: AnyObject {
    func searchResultViewCellDidTapCell(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    /// Can be used if TMDB is not working, I made use of OTT Details API.
//    public var titles: [SearchResult] = [SearchResult]()
    public var titles: [Title] = [Title]()
    
    weak var delegate: SearchResultViewCellDelegate?
    
    public let searchResultView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let searchResultView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchResultView.register(TitleCollectionViewCell.self,
                                  forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return searchResultView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(searchResultView)
        searchResultView.dataSource = self
        searchResultView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchResultView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }

        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_name ?? title.original_title ?? ""

        APICaller.shared.getMovies(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultViewCellDidTapCell(TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, overviewText: title.overview ?? ""))
 
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}
