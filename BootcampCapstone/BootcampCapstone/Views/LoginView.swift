//
//  LoginView.swift
//  BootcampCapstone
//  Created by Solomon Chambers on 9/17/26.
//  Modified by Mike Brueggman

import SwiftUI

struct LoginView: View {
    @State private var viewModel = ViewModel()
    @EnvironmentObject var authStatus: AuthStatus
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .accessibilityAddTraits(.isHeader)
                
                VStack(spacing: 16) {
                    TextField("Username", text: $viewModel.credentials.username)
                        .font(.body)
                        .padding()
                        .frame(minHeight: 44)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Username text field")
                    
                    SecureField("Password", text: $viewModel.credentials.password)
                        .font(.body)
                        .padding()
                        .frame(minHeight: 44)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .accessibilityLabel("Password text field")
                }
                
                if viewModel.isBusy {
                    ProgressView("Authenticating...")
                        .frame(minHeight: 44)
                }
                
                Button {
                    Task {
                        let response = await viewModel.login()
                        if let resp = response {
                            authStatus.updateLoginStatus(success: resp.success, authToken: resp.accessToken, refreshToken: resp.refreshToken)
                        }
                    }
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.loginDisabled)
                .accessibilityLabel("Log in button")
                .accessibilityHint("Authenticates credentials and opens application overview")
                
                if !viewModel.errorMessage.isEmpty {
                    Label(viewModel.errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .accessibilityLabel("Error: \(viewModel.errorMessage)")
                }
                
                Spacer(minLength: 20)
            }
            .padding(20)
        }
        .disabled(viewModel.isBusy)
    }
}