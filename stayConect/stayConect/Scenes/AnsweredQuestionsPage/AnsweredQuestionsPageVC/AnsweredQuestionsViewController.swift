//
//  AnsweredQuestionsViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import UIKit

final class AnsweredQuestionsViewController: UIViewController {
    private var timer: Timer?
    
    // MARK: - Elements
    private lazy var navigateBackButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.isEnabled = true
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.anekBold.rawValue, size: 20)
        label.text = "Answered Questions"
        label.textAlignment = .left
        
        return label
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
    
    private lazy var answeredQuestionsViewModel: AnsweredQuestionsViewModel = {
        return AnsweredQuestionsViewModel()
    }()
    
    private lazy var tagViewModel: TagViewModel = {
        return TagViewModel()
    }()
    
    var selectedTagId: Int? = nil
    var alertClass = AlertClass()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupUI()
        fetchQuestions()
        fetchTags()
        answeredQuestionsViewModel.answeredQuesitonsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.questionDisplayView.reloadData()
                self?.updateEmptyStateView()
            }
        }
    }
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(pageTitle)
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13)
        ])
        setupEmptyStateView()
        setupQuestionDisplayView()
        setupBackButton()
    }
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 30),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupQuestionDisplayView() {
        view.addSubview(questionDisplayView)
        
        NSLayoutConstraint.activate([
            questionDisplayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionDisplayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionDisplayView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor),
            questionDisplayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Fetch functions
    private func fetchQuestions() {
        Task {
            do {
                try await answeredQuestionsViewModel.fetchAnsweredQuestions()
                DispatchQueue.main.async { [weak self] in
                    self?.questionDisplayView.reloadData()
                    self?.updateEmptyStateView()
                }
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions. Please try again later.")
            }
        }
    }
    
    private func fetchTags() {
        Task {
            do {
                try await tagViewModel.fetchTags()
                DispatchQueue.main.async { [weak self] in
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
                let response = try await tagViewModel.fetchAnsweredQuestionsOnTag(tagId: tagId)
                DispatchQueue.main.async { [weak self] in
                    self?.updateQuestions(response.results)
                }
            } catch {
                alertClass.showAlert(message: "Failed to fetch questions for the selected tag. Please try again later.")
            }
        }
    }
    
    private func updateEmptyStateView() {
        let isEmpty = answeredQuestionsViewModel.isEmpty
        let hasSelectedTag = selectedTagId != nil
        toggleViewVisibility(isEmpty: isEmpty)
        
        if isEmpty && !hasSelectedTag {
            emptyStateView.configure(
                imageName: "HomeEmpty",
                primaryText: "You haven't answered any questions yet.",
                secondaryText: "Find a question on Home page to answer."
            )
        }
    }
    
    private func toggleViewVisibility(isEmpty: Bool) {
        let hasSelectedTag = selectedTagId != nil
        
        if isEmpty && !hasSelectedTag {
            setupEmptyStateView()
            emptyStateView.isHidden = false
            questionDisplayView.isHidden = true
        } else {
            setupQuestionDisplayView()
            emptyStateView.isHidden = true
            questionDisplayView.isHidden = false
            questionDisplayView.configureCollectionView(delegate: self, dataSource: self)
            questionDisplayView.configureTableView(delegate: self, dataSource: self)
            questionDisplayView.configureSearchBar(delegate: self)
            questionDisplayView.reloadData()
        }
    }
    
    // MARK: - Functions
    private func setupBackButton() {
        navigateBackButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigateBack()
        }), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigateBackButton)
    }
    
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func updateQuestions(_ questions: [Question]) {
        answeredQuestionsViewModel.updateQuestions(questions)
        questionDisplayView.reloadData()
        updateEmptyStateView()
    }
    private func query(_ text: String) async {
            do {
                try await answeredQuestionsViewModel.fetchAnsweredQuestions(query: text)
            } catch {
                print("Failed to fetch questions: \(error)")
            }
        }
}
// MARK: - Extensions

extension AnsweredQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answeredQuestionsViewModel.getQuestionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier, for: indexPath) as? QuestionCell else {
            return UITableViewCell()
        }
        let question = answeredQuestionsViewModel.getQuestions(indexPath.row)
        cell.configure(with: question, context: .answered)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = QuestionDetailsViewController()
        let selectedQuestion = answeredQuestionsViewModel.getQuestions(indexPath.row)
        detailsVC.questionId = selectedQuestion.id
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == answeredQuestionsViewModel.getQuestionsCount() - 1 {
            Task {
                do {
                    try await answeredQuestionsViewModel.fetchAnsweredQuestions(page: answeredQuestionsViewModel.currentPage + 1)
                } catch {
                    print("Failed to fetch more questions: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension AnsweredQuestionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension AnsweredQuestionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = tagViewModel.getTags(indexPath.item).name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 24)
    }
}

extension AnsweredQuestionsViewController: UISearchBarDelegate {
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

