//
//  AppleIDSignInView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/9/12.
//

import SwiftUI
import AuthenticationServices

struct AppleIDSignInView: View {
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResult):
                guard let credential = authResult.credential as? ASAuthorizationAppleIDCredential else {
                    return
                }
                let userId = credential.user
                let email = credential.email
                let fullname = credential.fullName
                
                print("User ID: \(userId)")
                print("Email: \(email ?? "nil")")
                print("Full Name: \(fullname?.givenName ?? "")")
                
            case .failure(let error):
                break
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .padding()

    }
}

#Preview {
    AppleIDSignInView()
}
