//
//  LoginPageViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//

import UIKit
import SwiftUI

final class LoginPageViewController: UIViewController {
    private let loginPageViewModel = LoginPageViewModel()
    private let pageWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Log in"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let emailAndUsernameTextFielStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#5E6366")
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 8
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let passowrdLabelAndForgotPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#5E6366")
        return label
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return button
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 8
        
        let lockContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        let lockImageView = UIImageView(image: UIImage(named: AppIcons.lockIcon.rawValue))
        lockImageView.tintColor = .gray
        lockImageView.contentMode = .scaleAspectFit
        lockImageView.frame = CGRect(x: 10, y: 0, width: 24, height: 24)
        lockContainer.addSubview(lockImageView)
        textField.leftView = lockContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return button
    }()
    
    private let newToStayConnectedAndSignupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let newToStayConnectedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New to Stay Connected?"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(.black), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor(.white), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(named: AppColors.primaryColor.rawValue)
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        setupPageWrapperView()
        setupPageLabel()
        setupEmailAndUsernameTextFielStackView()
        setupPasswordSrackView()
        setupNewToStayConnectedAndSignupStackView()
        setupLoginButton()
    }
    
    private func setupPageWrapperView() {
        view.addSubview(pageWrapperView)
        
        NSLayoutConstraint.activate([
            pageWrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            pageWrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageWrapperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 33),
            pageWrapperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -33)
        ])
    }
    
    private func setupPageLabel() {
        pageWrapperView.addSubview(pageLabel)
        
        NSLayoutConstraint.activate([
            pageLabel.centerXAnchor.constraint(equalTo: pageWrapperView.centerXAnchor),
            pageLabel.topAnchor.constraint(equalTo: pageWrapperView.topAnchor, constant: 120)
        ])
    }
    
    private func setupEmailAndUsernameTextFielStackView() {
        pageWrapperView.addSubview(emailAndUsernameTextFielStackView)
        [usernameLabel, usernameTextField].forEach{ emailAndUsernameTextFielStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            emailAndUsernameTextFielStackView.leadingAnchor.constraint(equalTo: pageWrapperView.leadingAnchor),
            emailAndUsernameTextFielStackView.trailingAnchor.constraint(equalTo: pageWrapperView.trailingAnchor),
            emailAndUsernameTextFielStackView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 75),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupPasswordSrackView() {
        pageWrapperView.addSubview(passwordStackView)
        [passowrdLabelAndForgotPasswordStackView, passwordTextField].forEach { passwordStackView.addArrangedSubview($0) }
        [passwordLabel, forgotPasswordButton].forEach { passowrdLabelAndForgotPasswordStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            passwordStackView.leadingAnchor.constraint(equalTo: pageWrapperView.leadingAnchor),
            passwordStackView.trailingAnchor.constraint(equalTo: pageWrapperView.trailingAnchor),
            passwordStackView.topAnchor.constraint(equalTo: emailAndUsernameTextFielStackView.bottomAnchor, constant: 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let eyeContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        eyeButton.frame = CGRect(x: 10, y: 13, width: 24, height: 24)
        eyeContainer.addSubview(eyeButton)
        
        passwordTextField.rightView = eyeContainer
        passwordTextField.rightViewMode = .always
        
        eyeButton.addAction(UIAction(handler: { [weak self] action in
            self?.togglePasswordVisibility()
        }), for: .touchUpInside)
    }
    
    private func setupNewToStayConnectedAndSignupStackView() {
        pageWrapperView.addSubview(newToStayConnectedAndSignupStackView)
        [newToStayConnectedLabel, signupButton].forEach{ newToStayConnectedAndSignupStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            newToStayConnectedAndSignupStackView.leadingAnchor.constraint(equalTo: pageWrapperView.leadingAnchor),
            newToStayConnectedAndSignupStackView.trailingAnchor.constraint(equalTo: pageWrapperView.trailingAnchor),
            newToStayConnectedAndSignupStackView.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 25)
        ])
        
        signupButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.pushViewController(SignupPageViewController(), animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupLoginButton() {
        pageWrapperView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: pageWrapperView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: pageWrapperView.trailingAnchor),
            loginButton.bottomAnchor.constraint(equalTo: pageWrapperView.bottomAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        loginButton.addAction(UIAction(handler: { [weak self] action in
            self?.loginButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func loginButtonTapped() {
        view.endEditing(true)
        ButtonAnimationUtility.animateButtonPress(loginButton)
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Task {
            do {
                let _ = try await loginPageViewModel.login(username: username, password: password)
                
                navigationController?.pushViewController(TabBarController(), animated: true)
            } catch LoginPageError.isValidUsername {
                showAlert(title: "Login Failed", message: "Username cannot be empty.")
            } catch LoginPageError.invalidPassword {
                showAlert(title: "Login Failed", message: "Password cannot be empty.")
            } catch {
                showAlert(title: "Login Failed", message: "An unexpected error occurred. Please try again later.")
            }
        }
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

