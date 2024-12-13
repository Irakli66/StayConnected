import Foundation
import NetworkPackage

final class SignupPageViewModel {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    private func validateFullName(username: String) -> Bool {
        // Regex allows letters and numbers but no spaces
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }
    
    private func validateEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    private func validatePassword(password: String) -> Bool {
        let regex = "(?=.*[A-Z])(?=.*[!@#$%]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func validateConfirmPassword(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    func registerUser(
        username: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async throws -> String {
        if !validateFullName(username: username) {
            throw ValidationError.invalidFullName
        }
        if !validateEmail(email: email) {
            throw ValidationError.invalidEmail
        }
        if !validatePassword(password: password) {
            throw ValidationError.invalidPassword
        }
        if !validateConfirmPassword(password: password, confirmPassword: confirmPassword) {
            throw ValidationError.passwordMismatch
        }
        
        let requestBody: [String: String] = [
            "username": username.lowercased(),
            "email": email,
            "password": password
        ]
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw ValidationError.invalidRequestData
        }
        
        let response: RegistrationResponse = try await networkService.request(
            urlString: "https://db.idk.ge/user/users/",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: bodyData,
            decoder: JSONDecoder()
        )
        
        return response.message
    }
}

enum ValidationError: LocalizedError {
    case invalidFullName
    case invalidEmail
    case invalidPassword
    case passwordMismatch
    case invalidRequestData
    
    var errorDescription: String? {
        switch self {
        case .invalidFullName:
            return "Full Name should only contain letters and numbers and no spaces."
        case .invalidEmail:
            return "Please enter a valid email."
        case .invalidPassword:
            return "Password must be at least 8 characters long, contain one uppercase letter, and one special character."
        case .passwordMismatch:
            return "Password and Confirm Password must match."
        case .invalidRequestData:
            return "Failed to prepare the request data."
        }
    }
}
