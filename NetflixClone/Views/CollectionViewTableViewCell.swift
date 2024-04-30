//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Kailash Bora on 22/04/24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel )
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"

    private var titles: [Title] = [Title]() 

    weak var delegate: CollectionViewTableViewCellDelegate?

    private let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 144, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }() 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(customCollectionView)

        customCollectionView.delegate = self
        customCollectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        customCollectionView.frame = contentView.bounds
    }

    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.customCollectionView.reloadData()
        }
    }

    private func downloadTitle(index: IndexPath) {
        let title = titles[index.row]
        DataPersistenceManager.shared.downloadTitleWith(model: title) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print("Error to download:\(error.localizedDescription)")
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
                                                            for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let title = title.original_name ?? title.original_title else {
            return
        }

        APICaller.shared.getMovies(with: title + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                guard let self else { return }
                let viewModel = TitlePreviewViewModel(title: title,
                                                      youtubeVideo: video,
                                                      overviewText: self.titles[indexPath.row].overview ?? "")
                self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)
 
            case .failure(let error):
                print("Failed to show video at index:\(indexPath) with error: \(error.localizedDescription)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                print("Download Tapped")
            }
            return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
