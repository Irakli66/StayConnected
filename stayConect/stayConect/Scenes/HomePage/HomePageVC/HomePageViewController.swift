//
//  HomePageViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//

import UIKit
import CustomSegmentedControl

final class HomePageViewController: UIViewController {
    private var timer: Timer?

    // MARK: - Elements
    private lazy var homePageHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var homePageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.anekBold.rawValue, size: 20)
        label.text = "Questions"
        
        return label
    }()
    
    private lazy var addQuestionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(symbolImage, for: .normal)
        button.tintColor = UIColor(named: "MainColor")
        
        return button
    }()
    
    private lazy var customSegmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.items = ["General", "Personal"]
        control.thumbColor = UIColor(named: AppColors.primaryColor.rawValue) ?? .blue
        control.inactiveColor = UIColor(named: AppColors.inactiveButtonColor.rawValue) ?? .blue
        control.selectedTextColor = .white
        control.inactiveTextColor = .white
        control.segmentSpacing = 10
        control.selectedIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        return control
    }()
    
    private lazy var questionDisplayView: QuestionDisplayView = {
        let view = QuestionDisplayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        
        return view
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()
    
    private lazy var questionCell = QuestionCell()
    
    private lazy var viewModel: QuestionViewModel = {
        return QuestionViewModel()
    }()
    
    private lazy var tagViewModel: TagViewModel = {
        return TagViewModel()
    }()
    
    var selectedTagId: Int? = nil
    var alertClass = AlertClass()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchQuestions()
        fetchTags()
        viewModel.questionsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.questionDisplayView.reloadData()
                self?.updateEmptyStateView()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuestionCreated), name: NSNotification.Name("QuestionCreated"), object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchQuestions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupPageHeader()
        setupSegmentedControl()
        setupEmptyStateView()
        setupQuestionDisplayView()
    }
    
    private func setupPageHeader() {
        homePageHeader.addSubview(homePageTitle)
        homePageHeader.addSubview(addQuestionButton)
        view.addSubview(homePageHeader)
        
        NSLayoutConstraint.activate([
            homePageHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homePageHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homePageHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homePageHeader.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            homePageTitle.centerYAnchor.constraint(equalTo: homePageHeader.centerYAnchor),
            homePageTitle.leadingAnchor.constraint(equalTo: homePageHeader.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            addQuestionButton.centerYAnchor.constraint(equalTo: homePageHeader.centerYAnchor),
            addQuestionButton.trailingAnchor.constraint(equalTo: homePageHeader.trailingAnchor, constant: -30)
        ])
        
        addQuestionButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.present(CreateQuestionViewController(), animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupSegmentedControl() {
        view.addSubview(customSegmentedControl)
        
        NSLayoutConstraint.activate([
            customSegmentedControl.topAnchor.constraint(equalTo: homePageTitle.bottomAnchor, constant: 20),
            customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 30),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupQuestionDisplayView() {
        view.addSubview(questionDisplayView)
        
        NSLayoutConstraint.activate([
            questionDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionDisplayView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor),
            questionDisplayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Fetch functions
    private func fetchQuestions() {
        Task {
            do {
                try await viewModel.fetchQuestions()
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions. Please try again later.")
            }
        }
    }
    
    private func fetchTags() {
        Task {
            do {
                try await tagViewModel.fetchTags()
                DispatchQueue.main.async {[weak self] in
                    self?.questionDisplayView.reloadCollection()
                }
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions. Please try again later.")
            }
        }
    }
    
    private func fetchQuestionsByTag(tagId: Int) {
        Task {
            do {
                let response = try await tagViewModel.fetchQuestionsOnTag(tagId: tagId)
                DispatchQueue.main.async { [weak self] in
                    self?.updateQuestions(response.results)
                }
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions. Please try again later.")
            }
        }
    }
    
    @objc private func handleQuestionCreated() {
        fetchQuestions()
    }
    
    private func fetchPersonalQuestions() {
        Task {
            do {
                try await viewModel.fetchPersonalQuestions()
                DispatchQueue.main.async { [weak self] in
                    self?.questionDisplayView.reloadData()
                    self?.updateEmptyStateView()
                }
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions. Please try again later.")
            }
        }
    }
    
    // MARK: - View setup functions
    
    @objc private func segmentedControlValueChanged() {
        if customSegmentedControl.selectedIndex == 0 {
            fetchQuestions()
        } else if customSegmentedControl.selectedIndex == 1 {
            fetchPersonalQuestions()
        }
    }
    
    private func updateEmptyStateView() {
        let isEmpty = viewModel.isEmpty
        let hasSelectedTag = selectedTagId != nil
        
        if isEmpty && !hasSelectedTag {
            emptyStateView.isHidden = false
            questionDisplayView.isHidden = true
            
            if customSegmentedControl.selectedIndex == 0 {
                emptyStateView.configure(
                    imageName: "HomeEmpty",
                    primaryText: "No questions yet",
                    secondaryText: "Be the first to ask one"
                )
            } else {
                emptyStateView.configure(
                    imageName: "HomeEmpty",
                    primaryText: "Got a question in mind?",
                    secondaryText: "Ask it and wait for like-minded people\n to answer"
                )
            }
        } else {
            emptyStateView.isHidden = true
            questionDisplayView.isHidden = false
            questionDisplayView.configureCollectionView(delegate: self, dataSource: self)
            questionDisplayView.configureTableView(delegate: self, dataSource: self)
            questionDisplayView.configureSearchBar(delegate: self)
            questionDisplayView.reloadData()
        }
    }
    
    
    private func toggleViewVisibility(isEmpty: Bool) {
        let hasSelectedTag = selectedTagId != nil
        
        if isEmpty && !hasSelectedTag {
            emptyStateView.isHidden = false
            questionDisplayView.isHidden = true
        } else {
            emptyStateView.isHidden = true
            questionDisplayView.isHidden = false
            questionDisplayView.configureCollectionView(delegate: self, dataSource: self)
            questionDisplayView.configureTableView(delegate: self, dataSource: self)
            questionDisplayView.reloadData()
        }
    }
    
    private func updateQuestions(_ questions: [Question]) {
        viewModel.updateQuestions(questions)
        questionDisplayView.reloadData()
        updateEmptyStateView()
    }
    
    private func query(_ text: String) async {
            do {
                try await viewModel.fetchQuestions(query: text)
            } catch {
                print("Failed to fetch questions: \(error)")
            }
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("QuestionCreated"), object: nil)
        print("HomePageViewController has been deallocated.")
    }
}

// MARK: - Extensions

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getQuestionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier, for: indexPath) as? QuestionCell else {
            return UITableViewCell()
        }
        let question = viewModel.getQuestions(indexPath.row)
        cell.configure(with: question, context: .home)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = QuestionDetailsViewController()
        let selectedQuestion = viewModel.getQuestions(indexPath.row)
        detailsVC.questionId = selectedQuestion.id
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getQuestionsCount() - 1 {
            Task {
                do {
                    try await viewModel.fetchQuestions(page: viewModel.currentPage + 1)
                } catch {
                    print("Failed to fetch more questions: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return tagViewModel.getTagsCount()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        
        if collectionView.tag == 1 {
            let tag = tagViewModel.getTags(indexPath.item)
            let isSelected = (tag.id == selectedTagId)
            cell.configure(with: tag.name, isSelected: isSelected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let selectedTag = tagViewModel.getTags(indexPath.item)
            
            if selectedTagId == selectedTag.id {
                selectedTagId = nil
                fetchQuestions()
            } else {
                selectedTagId = selectedTag.id
                fetchQuestionsByTag(tagId: selectedTag.id)
            }
            
            collectionView.reloadData()
        }
    }
    
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = tagViewModel.getTags(indexPath.item).name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 24)
    }
}

extension HomePageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self, !searchText.isEmpty else { return }
            Task {
                await self.query(searchText)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else { return }
        Task {
            await query(text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        Task {
            await query("")
        }
    }
}
