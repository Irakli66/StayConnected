//
//  CreateQuestionViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import UIKit

final class CreateQuestionViewController: UIViewController {
    private let createQuestionViewModel = CreateQuestionViewModel()
    private var selectedTags: [Tag] = []
    
    private let pageHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: AppColors.secondaryColor.rawValue)
        return view
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Add Question"
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: AppColors.primaryColor.rawValue), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let subjectTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Subject:"
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var dividerOne: UIView = createDividerView()
    
    private let selectedTagsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#909093")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Tag:"
        return label
    }()
    
    private let selectedTagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var dividerTwo: UIView = createDividerView()
    
    private let tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var questionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your question here"
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
        sendButton.addTarget(self, action: #selector(addQuestion), for: .touchUpInside)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        sendButton.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        rightPaddingView.addSubview(sendButton)
        
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Task {
            do {
                try await createQuestionViewModel.fetchTags()
                tagsCollectionView.reloadData()
                selectedTagsCollectionView.reloadData()
            } catch {
                print("Error fetching tag data: \(error.localizedDescription)")
            }
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupHeader()
        setupSubjectTextField()
        setupSelectedTags()
        setupTagsCollectionView()
        setupQuestionTextField()
    }
    
    private func setupHeader() {
        view.addSubview(pageHeaderView)
        [pageTitleLabel, cancelButton].forEach{ pageHeaderView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            pageHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            pageHeaderView.heightAnchor.constraint(equalToConstant: 80),
            
            pageTitleLabel.centerXAnchor.constraint(equalTo: pageHeaderView.centerXAnchor),
            pageTitleLabel.centerYAnchor.constraint(equalTo: pageHeaderView.centerYAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: pageTitleLabel.trailingAnchor, constant: 65),
            cancelButton.centerYAnchor.constraint(equalTo: pageTitleLabel.centerYAnchor)
        ])
        
        cancelButton.addAction(UIAction(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupSubjectTextField() {
        view.addSubview(subjectTextField)
        view.addSubview(dividerOne)
        
        NSLayoutConstraint.activate([
            subjectTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            subjectTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            subjectTextField.topAnchor.constraint(equalTo: pageHeaderView.bottomAnchor, constant: 10),
            subjectTextField.heightAnchor.constraint(equalToConstant: 45),
            
            dividerOne.leftAnchor.constraint(equalTo: view.leftAnchor),
            dividerOne.topAnchor.constraint(equalTo: subjectTextField.bottomAnchor, constant: 5),
            dividerOne.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
    }
    
    private func setupSelectedTags() {
        view.addSubview(selectedTagsView)
        selectedTagsView.addSubview(tagLabel)
        selectedTagsView.addSubview(selectedTagsCollectionView)
        view.addSubview(dividerTwo)
        
        NSLayoutConstraint.activate([
            selectedTagsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            selectedTagsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            selectedTagsView.topAnchor.constraint(equalTo: dividerOne.topAnchor, constant: 5),
            selectedTagsView.heightAnchor.constraint(equalToConstant: 45),
            
            tagLabel.leftAnchor.constraint(equalTo: selectedTagsView.leftAnchor, constant: 20),
            tagLabel.centerYAnchor.constraint(equalTo: selectedTagsView.centerYAnchor),
            
            selectedTagsCollectionView.centerYAnchor.constraint(equalTo: selectedTagsView.centerYAnchor),
            selectedTagsCollectionView.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 10),
            selectedTagsCollectionView.trailingAnchor.constraint(equalTo: selectedTagsView.trailingAnchor),
            selectedTagsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            dividerTwo.leftAnchor.constraint(equalTo: view.leftAnchor),
            dividerTwo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            dividerTwo.topAnchor.constraint(equalTo: selectedTagsView.bottomAnchor, constant: 5),
        ])
        
        selectedTagsCollectionView.tag = 0
        selectedTagsCollectionView.dataSource = self
        selectedTagsCollectionView.delegate = self
        selectedTagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
    }
    
    private func setupTagsCollectionView() {
        view.addSubview(tagsCollectionView)
        tagsCollectionView.tag = 1
        
        NSLayoutConstraint.activate([
            tagsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tagsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tagsCollectionView.topAnchor.constraint(equalTo: dividerTwo.bottomAnchor, constant: 10),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
    }
    
    private func setupQuestionTextField() {
        view.addSubview(questionTextField)
        
        NSLayoutConstraint.activate([
            questionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            questionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            questionTextField.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 30),
            questionTextField.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func createDividerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    @objc private func addQuestion() {
        guard let subject = subjectTextField.text, !subject.trimmingCharacters(in: .whitespaces).isEmpty,
              let question = questionTextField.text, !question.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in both the subject and question fields.")
            return
        }
            
        Task {
            do {
                let _ = try await  createQuestionViewModel.addQuestion(title: subject, content: question, tags: selectedTags)
                subjectTextField.text = ""
                selectedTags = []
                questionTextField.text = ""
                selectedTagsCollectionView.reloadData()
                tagsCollectionView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("QuestionCreated"), object: nil)
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }
            } catch {
                print("Error creating question: \(error)")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension CreateQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return selectedTags.count
        } else {
            return createQuestionViewModel.getTagsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView.tag == 0 {
            let currentTag = selectedTags[indexPath.row]
            cell.configureCell(with: currentTag)
        } else {
            let currentTag = createQuestionViewModel.getTag(at: indexPath.row)
            cell.configureCell(with: currentTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let currentTag = createQuestionViewModel.getTag(at: indexPath.row)
            
            if !selectedTags.contains(where: { $0.id == currentTag.id }) {
                selectedTags.append(currentTag)
                selectedTagsCollectionView.reloadData()
                tagsCollectionView.reloadData()
            } else {
                print("Tag '\(currentTag.name)' is already in selectedTags.")
            }
        } else if collectionView.tag == 0 {
            let currentTag = selectedTags[indexPath.row]
            selectedTags.removeAll(where: { $0.id == currentTag.id })
            selectedTagsCollectionView.reloadData()
            tagsCollectionView.reloadData()
        }
    }
}

extension CreateQuestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = createQuestionViewModel.getTag(at: indexPath.row).name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 24)
    }
}
