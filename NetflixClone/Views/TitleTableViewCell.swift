//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Kailash Bora on 24/04/24.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"

    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()

    private let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titlePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLable)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyConstraints() {
        let titlePosterImageViewConstraints = [
            titlePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]

        let titleLableConstraints = [
            titleLable.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 20),
            titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        let playTitleButtonConstraints = [
            playTitleButton.leadingAnchor.constraint(equalTo: titleLable.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(titlePosterImageViewConstraints)
        NSLayoutConstraint.activate(titleLableConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }

    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterUrl)") else { return }
        titlePosterImageView.sd_setImage(with: url, completed: nil)
        titleLable.text = model.titleName
    }
}
