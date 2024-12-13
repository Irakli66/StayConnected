//
//  QuestionDetailsViewController.swift
//  stayConect
//
//  Created by Nkhorbaladze on 03.12.24.
//

import UIKit

final class QuestionDetailsViewController: UIViewController {
    let questionDetailsViewModel = QuestionDetailsViewModel()
    // MARK: - Elements
    private var expandedCells: Set<IndexPath> = []
    var questionId: Int? = 0
    
    private lazy var questionSubjectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Swift Operators"
        
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "VoiceOver is a central part of Apple's accessibility system, to the point not accessible to other accessibility systems in iOS?"
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var usernameAndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@userNameHere asked on 11/24/2024 at 0:33"
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private let navigateBackButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.isEnabled = true
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var answersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    private lazy var answerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your reply here"
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#858585")?.cgColor
        textField.clipsToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: AppIcons.sendIconActive.rawValue), for: .normal)
        sendButton.tintColor = UIColor(hex: "#909093")
        sendButton.addAction(UIAction(handler: { [weak self] action in
            self?.addAnswer()
        }), for: .touchUpInside)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        sendButton.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        rightPaddingView.addSubview(sendButton)
        
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private lazy var viewModel: QuestionViewModel = {
        return QuestionViewModel()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        navigationController?.setNavigationBarHidden(false, animated: false)
        fetchQuestiondetails()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(questionSubjectLabel)
        view.addSubview(questionLabel)
        view.addSubview(usernameAndDateLabel)
        view.addSubview(answersTableView)
        view.addSubview(answerTextField)
        
        NSLayoutConstraint.activate([
            questionSubjectLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionSubjectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionSubjectLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: questionSubjectLabel.bottomAnchor, constant: 4),
            questionLabel.leadingAnchor.constraint(equalTo: questionSubjectLabel.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: questionSubjectLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernameAndDateLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 4),
            usernameAndDateLabel.leadingAnchor.constraint(equalTo: questionSubjectLabel.leadingAnchor),
            usernameAndDateLabel.trailingAnchor.constraint(equalTo: questionSubjectLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            answerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            answerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            answerTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            answerTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            answersTableView.topAnchor.constraint(equalTo: usernameAndDateLabel.bottomAnchor, constant: 17),
            answersTableView.leadingAnchor.constraint(equalTo: questionSubjectLabel.leadingAnchor),
            answersTableView.trailingAnchor.constraint(equalTo: questionSubjectLabel.trailingAnchor),
            answersTableView.bottomAnchor.constraint(equalTo: answerTextField.topAnchor, constant: -10)
        ])
        
        setupBackButton()
    }
    
    // MARK: - Configuration
    private func setupBackButton() {
        navigateBackButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigateBack()
        }), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigateBackButton)
    }
    
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchQuestiondetails() {
        Task {
            do {
                try await questionDetailsViewModel.fetchQuestion(with: questionId ?? 0)
                answersTableView.reloadData()
                updateUI()
            } catch {
                print("failed fetching details: \(error)")
            }
        }
    }
    
    private func updateUI() {
        guard let question = questionDetailsViewModel.question else { return }
        questionSubjectLabel.text = question.title
        questionLabel.text = question.content
        let createdAt = questionDetailsViewModel.formatDate(date: question.createdAt)
        usernameAndDateLabel.text = "@\(question.authorUsername) asked on \(createdAt)"
    }
    
    private func addAnswer() {
        guard let content = answerTextField.text, !content.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Error", message: "Answer cannot be empty.")
            return
        }
        
        Task {
            do {
                let _ = try await questionDetailsViewModel.addAnswer(questionId: questionId ?? 0, content: content)
                DispatchQueue.main.async { [weak self] in
                    self?.fetchQuestiondetails()
                    self?.answersTableView.reloadData()
                    self?.answerTextField.text = ""
                }
            } catch {
                print("Error creating question: \(error)")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension QuestionDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionDetailsViewModel.getAnswersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as? AnswerCell else {
            return UITableViewCell()
        }
        if let currentAnswer = questionDetailsViewModel.getAnswer(at: indexPath.row) {
            let isExpanded = expandedCells.contains(indexPath)
            cell.configure(with: currentAnswer, isExpanded: isExpanded)
        } else {
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedCells.contains(indexPath) {
            expandedCells.remove(indexPath)
        } else {
            expandedCells.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let answer = questionDetailsViewModel.getAnswer(at: indexPath.row) else { return nil }
        
        let isUserOwner = questionDetailsViewModel.isUserQuestionOwner(with: questionDetailsViewModel.question?.author ?? 0)
        
        if !isUserOwner {
            return nil
        }
        
        let hasAcceptedAnswer = questionDetailsViewModel.question?.answers.contains { $0.isAccepted } ?? false
        
        if hasAcceptedAnswer {
            if answer.isAccepted {
                let rejectAction = UIContextualAction(style: .normal, title: "Reject") { [weak self] _, _, completionHandler in
                    guard let self = self else { return }
                    Task {
                        do {
                            try await self.questionDetailsViewModel.rejectAnswer(with: answer.id)
                            DispatchQueue.main.async {
                                self.fetchQuestiondetails()
                                self.answersTableView.reloadData()
                                completionHandler(true)
                            }
                        } catch {
                            print("Failed to reject answer: \(error)")
                            completionHandler(false)
                        }
                    }
                }
                rejectAction.backgroundColor = UIColor(hex: "EC5454")
                return UISwipeActionsConfiguration(actions: [rejectAction])
            } else {
                return nil
            }
        } else {
            let acceptAction = UIContextualAction(style: .normal, title: "Accept") { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                Task {
                    do {
                        try await self.questionDetailsViewModel.acceptAnswer(with: answer.id)
                        DispatchQueue.main.async {
                            self.fetchQuestiondetails()
                            self.answersTableView.reloadData()
                            completionHandler(true)
                        }
                    } catch {
                        print("Failed to accept answer: \(error)")
                        completionHandler(false)
                    }
                }
            }
            acceptAction.backgroundColor = UIColor(hex: "4E53A2")
            return UISwipeActionsConfiguration(actions: [acceptAction])
        }
    }
    
}



