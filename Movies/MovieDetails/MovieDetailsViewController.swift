//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import UIKit
import RxSwift
import RxDataSources

class MovieDetailsViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieDetailsTableViewCell.self, forCellReuseIdentifier: "movieDetails")
        tableView.register(PersonInfoTableViewCell.self, forCellReuseIdentifier: "person")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.keyboardDismissMode = .interactive
        tableView.tableHeaderView = UIView(frame: .zero)
        return tableView
    }()
    
    var viewModel: MovieDetailsViewModel
    
    init(with movie: Movie) {
        self.viewModel = MovieDetailsViewModel(movie: movie, movieService: MovieServiceImpl(), imageService: ImageServiceImpl())
        super.init(nibName: nil, bundle: nil)
    }
    
    init(with personCredit: PersonCredit) {
        self.viewModel = MovieDetailsViewModel(personCredit: personCredit, movieService: MovieServiceImpl(), imageService: ImageServiceImpl())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildUI()
        bindUI()
        viewModel.loadMovieDetails()
    }
    
    // MARK: - UI
    
    private func buildUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Binding
    
    private func bindUI() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<MovieDetailsViewModel.Section>.init { (section, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .cast(model: let cast):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "person") as? PersonInfoTableViewCell else {
                    fatalError()
                }
                cell.configure(with: PersonInfoTableViewCellViewModelImpl(with: cast))
                return cell
            case .movieDetail(model: let details):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieDetails") as? MovieDetailsTableViewCell else {
                    fatalError()
                }
                cell.configure(with: MovieDetailsTableViewCellViewModelImpl(movieDetail: details))
                return cell
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            switch dataSource.sectionModels[index].model {
            case .cast:
                return "Cast"
            default:
                return nil
            }
        }
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MovieDetailsViewModel.TableItem.self)
            .subscribe(onNext: { [weak self] item in
                switch item {
                case .cast(model: let cast):
                    let vc = PersonDetailsViewController(with: cast)
                    self?.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
