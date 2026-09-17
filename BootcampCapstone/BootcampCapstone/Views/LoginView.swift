//
//  LoginView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = ViewModel()
    @EnvironmentObject var authStatus: AuthStatus
    
    var body: some View {
        VStack {
            Spacer()
            Text("Login")
                .font(.custom("Inter-Regular", size: 45, relativeTo: .body).bold())
            Spacer()
            TextField("Username", text: $viewModel.credentials.username)
                .font(.custom("Inter-Regular", size: 25, relativeTo: .body))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Spacer().frame(height: 20)
            SecureField("Password", text: $viewModel.credentials.password)
                .font(.custom("Inter-Regular", size: 25, relativeTo: .body))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            if viewModel.isBusy { ProgressView() }
            Spacer()
            
            Button {
                Task {
                    let response = await viewModel.login()
                    if let resp = response {
                        authStatus.updateLoginStatus(success: resp.success, authToken: resp.accessToken, refreshToken: resp.refreshToken)
                    }
                }
            } label: {
                Text("Log in")
                    .font(.custom("Inter-Regular", size: 25, relativeTo: .body))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.loginDisabled ? .gray : .blue)
            .disabled(viewModel.loginDisabled)
            .padding(.horizontal)
            .padding(.bottom, 24)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                .foregroundColor(Color.red)
            }
        }
        .padding(20)
        .autocapitalization(.none)
        .disabled(viewModel.isBusy)
    }
}

extension LoginView {
    @Observable
    class ViewModel {
        var credentials = LoginModel()
        var isBusy = false
        
        var loginDisabled: Bool {
            credentials.username.isEmpty || credentials.password.isEmpty
        }
        var errorMessage: String = ""
        
        func login() async -> LoginResponse? {
            isBusy = true
            do {
                let result = try await AuthService.shared.login(credentials: credentials)
                isBusy = false
                if !result.success {
                    errorMessage = "Invalid username/password combination"
                }
                return result
            } catch {
                errorMessage = "\(error)"
            }
            isBusy = false
            return nil
        }
    }
}
