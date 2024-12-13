//
//  QuestionDisplayView.swift
//  stayConect
//
//  Created by Nkhorbaladze on 30.11.24.
//

import UIKit

final class QuestionDisplayView: UIView {
    
    // MARK: - Elements
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "search"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.tag = 1
        
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    private lazy var searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "FAFAFA")
        
        return view
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBarView()
        setupTableView()
        tagsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchBarView()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupSearchBarView() {
        searchBarView.addSubview(searchBar)
        searchBarView.addSubview(tagsCollectionView)
        addSubview(searchBarView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchBarView.topAnchor, constant: 19),
            searchBar.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            tagsCollectionView.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 24),
            tagsCollectionView.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -16),
            tagsCollectionView.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -19),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: self.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableViewContainer.addSubview(tableView)
        addSubview(tableViewContainer)
        
        NSLayoutConstraint.activate([
            tableViewContainer.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tableViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Functions
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        tagsCollectionView.delegate = delegate
        tagsCollectionView.dataSource = dataSource
    }
    
    func configureSearchBar(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }

    func configureTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadCollection() {
        tagsCollectionView.reloadData()
    }
}
