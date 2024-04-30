//
//  DownloadViewController.swift
//  NetflixClone
//
//  Created by Kailash Bora on 22/04/24.
//

import UIKit

class DownloadViewController: UIViewController {

    private var titles: [NetflixCloneEntity] = [NetflixCloneEntity]()

    private let downloadTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self,
                           forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTableView)
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        fetchTitleFromLocalDatabase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchTitleFromLocalDatabase()
        }
    }

    private func fetchTitleFromLocalDatabase() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,
                                                       for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.orignial_title ?? title.original_name) ?? "Unknown ",
                                            posterUrl: title.poster_path ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = titles[indexPath.row]
        guard let titleName = movie.original_name ?? movie.orignial_title else { return }

        APICaller.shared.getMovies(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, overviewText: movie.overview ?? "")
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("Deletion success")
                case .failure(let error):
                    print("Failed to delete with error: \(error.localizedDescription)")
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
}
