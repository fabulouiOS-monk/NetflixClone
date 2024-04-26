//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Kailash Bora on 26/04/24.
//

import UIKit

class SearchResultViewController: UISearchController {

    private var titles: [Title] = [Title]()
    
    private let searchResultView: UICollectionView = {
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
        20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.backgroundColor = .blue
        
        return cell
    }
}
