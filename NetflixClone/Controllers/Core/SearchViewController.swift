//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Kailash Bora on 22/04/24.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = [Title]()

    private let topSearchTableView: UITableView  = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()

    private let searchResultView: UISearchController = {
        let searchResultView = UISearchController(searchResultsController: SearchResultViewController())
        searchResultView.searchBar.placeholder = "Search for Movies or Tv shows"
        searchResultView.searchBar.searchBarStyle = .minimal
        return searchResultView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(topSearchTableView)
        topSearchTableView.delegate = self
        topSearchTableView.dataSource = self
        navigationItem.searchController = searchResultView
        navigationController?.navigationBar.tintColor = .white

        fetchDiscoverMovies()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topSearchTableView.frame = view.bounds
    }

    public func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.topSearchTableView.reloadData()
                }

            case .failure(let error):
                print("Error while fetching Discover: \(error.localizedDescription)")
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        let title = titles[indexPath.row]
        let viewModel = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown",
                                       posterUrl: title.poster_path ?? "")
        cell.configure(with: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
