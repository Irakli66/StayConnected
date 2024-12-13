# Stay Connected  

**Stay Connected** is an iOS app designed to bring developers together in a collaborative environment. Users can post questions, share knowledge, and engage with the developer community. This app leverages Swift and UIKit to deliver a seamless experience while ensuring secure authentication using JWT.  

## Features  

### 🛠 User Authentication  
- **Registration/Login**: Create a new account or log in with an existing one.  
- **Persistent Login**: User credentials are securely stored in the Keychain, so you remain logged in even after closing the app.  

### 👤 Profile & Stats  
- View your profile page, including your current **score** and the **number of questions answered**.  

### ❓ Ask Questions  
- Post questions to the community, including optional **tags** for better categorization.  
- Accept answers that solve your problem, or reject them in favor of better solutions.  

### 🔍 Search Questions  
- Search for questions by **tags** or **titles** for quick access to relevant topics.  

### 🏆 Earn Points  
- Earn **100 points** every time one of your answers is accepted as the correct solution.  

## Tech Stack  

- **Programming Language**: Swift  
- **Framework**: UIKit  
- **Authentication**: JWT (JSON Web Token)  
- **Version Control**: GIT  

## How It Works  

1. **Register/Login**: New users can sign up, while existing users can log in. Once authenticated, the app securely stores tokens using Keychain for future logins.  
2. **Post Questions**: Users can ask questions, add tags for context, and await answers from the community.  
3. **Answer Management**: Question askers can accept or reject answers based on their relevance or accuracy.  
4. **Search Functionality**: Developers can search the app’s database for questions, filtering by tags or titles.  
5. **Earn Rewards**: Engage with the community by answering questions and earning points for accepted answers.  

## Installation  

1. Clone this repository:  
   ```bash  
   git clone https://github.com/Irakli66/StayConnected.git
