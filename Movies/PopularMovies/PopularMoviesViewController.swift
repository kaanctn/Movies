//
//  PopularMoviesViewController.swift
//  Movies
//
//  Created by Kaan Çetin  on 1.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PopularMoviesViewController: UIViewController {
        
    var disposeBag = DisposeBag()
    var viewModel: PopularMoviesViewModel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PopularMoviesViewModel(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movie")
        tableView.register(PersonInfoTableViewCell.self, forCellReuseIdentifier: "person")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.tableHeaderView = UIView(frame: .zero)
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by movie, genre or artist"
        return searchBar
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildUI()
        bindUI()
        viewModel.loadPopularMovies()
        viewModel.loadGenres()
    }
    
    private func buildUI() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationItem.titleView = searchBar
    }
    
    private func bindUI() {
        
        viewModel.state
            .bind { [weak self] (state) in
                switch state {
                case .loading:
                    self?.view.startLoading()
                    //self?.loadingIndicator.isHidden = false
                    self?.tableView.isHidden = true
                    self?.emptyLabel.isHidden = true
                case .list, .search:
                    //self?.loadingIndicator.isHidden = true
                    self?.view.endLoading()
                    self?.tableView.isHidden = false
                    self?.emptyLabel.isHidden = true
                case .empty:
                    //self?.loadingIndicator.isHidden = true
                    self?.view.endLoading()
                    self?.tableView.isHidden = true
                    self?.emptyLabel.isHidden = false
                    self?.emptyLabel.text = "Nothing for '\(self?.searchBar.text ?? "")'"
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.search(query: query)
            })
            .disposed(by: disposeBag)
    }
}

extension PopularMoviesViewController: PopularMoviesView {
    
    func onReloadIndexPaths(indexPaths: [IndexPath]) {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        let indexPathsIntersection = Set(visibleIndexPaths).intersection(indexPaths)
        if indexPathsIntersection.isEmpty {
            return
        }
        tableView.reloadItemsAtIndexPaths(Array(indexPathsIntersection), animationStyle: .automatic)
    }
    
    func onDataChanged() {
        tableView.reloadData()
    }
    
    func onError(error: Error) {
        let vc = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
    
    func onMovieDetails(movie: Movie) {
        let details = MovieDetailsViewController(with: movie)
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    func onPersonDetails(person: Person) {
        let details = PersonDetailsViewController(with: person)
        self.navigationController?.pushViewController(details, animated: true)
    }
}

extension PopularMoviesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.section(for: indexPath.section) {
        case .movieSearch:
            fallthrough
        case .popularMovies:
            fallthrough
        case .discover:
            return makeMovieCell(tableView: tableView, cellForRowAt: indexPath)
        case .peopleSearch:
            return makePersonCell(tableView: tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle(for: section)
    }
    
    private func makeMovieCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MovieTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieTableViewCell else {
            fatalError("Unable to deqeue MovieTableViewCell with identifier: movie")
        }
        if let vm = viewModel.movieTableViewCellViewModel(for: indexPath.row, in: indexPath.section) {
            cell.configure(with: vm)
        } else {
            cell.configureAsLoading()
        }
        return cell
    }
    
    private func makePersonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PersonInfoTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "person") as? PersonInfoTableViewCell else {
            fatalError("Unable to deqeue MovieTableViewCell with identifier: movie")
        }
        if let vm = viewModel.personInfoTableViewCellViewModel(for: indexPath.row, in: indexPath.section) {
            cell.configure(with: vm)
        }
        return cell
    }
}

extension PopularMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension PopularMoviesViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchPopularMoviesAt(indexPaths: indexPaths)
    }
}
