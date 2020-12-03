//
//  PersonDetailsViewController.swift
//  Movies
//
//  Created by Kaan Çetin  on 2.12.2020.
//

import UIKit
import RxSwift

class PersonDetailsViewController: UIViewController {
    
    var viewModel: PersonDetailsViewModel!
    var disposeMap = Dictionary<IndexPath, Disposable>()
    
    init(with person: Person) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PersonDetailsViewModel(person: person, personService: PersonServiceImpl(), view: self)
    }
    
    init(with cast: Cast) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PersonDetailsViewModel(cast: cast, personService: PersonServiceImpl(), view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonInfoTableViewCell.self, forCellReuseIdentifier: "person")
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movie")
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: .zero)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildUI()
        viewModel.loadPersonDetails()
    }
    
    private func buildUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension PersonDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.section(for: indexPath.section) {
        case .cast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieTableViewCell else {
                fatalError("Unable to deqeue MovieTableViewCell with identifier: movie")
            }
            cell.configure(with: viewModel.movieTableViewCellViewModel(for: indexPath.row, in: indexPath.section))
            return cell
        case .crew:
            var cell = tableView.dequeueReusableCell(withIdentifier: "credit")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "credit")
            }
            cell?.configure(with: viewModel.personCreditCellViewModel(for: indexPath.row, in: indexPath.section))
            return cell!
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "person") as? PersonInfoTableViewCell else {
                fatalError("Unable to deqeue PersonInfoTableViewCell with identifier: person")
            }
            cell.configure(with: viewModel.personInfoTableViewCellViewModel())
            return cell
        case .biography:
            var cell = tableView.dequeueReusableCell(withIdentifier: "biography")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "biography")
            }
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.text = viewModel.biography()
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle(for: section)
    }
}

extension PersonDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row, section: indexPath.section)
    }
}

extension PersonDetailsViewController: PersonDetailsView {
    
    func onError(message: String) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        vc.addAction(.init(title: "OK", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(vc, animated: true, completion: nil)
    }
    
    func onDataChanged() {
        tableView.reloadData()
    }
    
    func onPersonCredit(credit: PersonCredit) {
        let vc = MovieDetailsViewController(with: credit)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

fileprivate extension UITableViewCell {
    
    func configure(with vm: PersonCreditCellViewModel) {
        textLabel?.text = vm.title
        textLabel?.numberOfLines = 0
        detailTextLabel?.text = vm.subtitle
        selectionStyle = .none
    }
}
