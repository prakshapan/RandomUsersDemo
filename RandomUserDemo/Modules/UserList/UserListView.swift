//
//  UserListView.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Combine
import SwiftUI

struct UserListView: View {

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        userListView
            .onAppear(perform: initialSetup)
            .preferredColorScheme(viewModel.isLightMode ? .light : .dark)
            .appAlert(parameters: $viewModel.alertParameters)
    }

    private var userListView: some View {
        VStack {
            titleView
            if !viewModel.isLoading && viewModel.userResults?.results == nil {
                noUsers
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(Array((viewModel.userResults?.results ?? UserResults.mockUsers).enumerated()),
                                id: \.element) { index, user in
                            configureUserCell(with: user, at: index)
                        }
                    }.padding(.horizontal)
                })
            }
        }
    }

    private var noUsers: some View {
        VStack {
            Spacer()
            Text(AppTexts.noUsers)
            Spacer()
        }
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(AppTexts.randomUsers)
                    .foregroundColor(Color.titleColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.all)
                Spacer()
                darkModeView
            }
            customizeListView
        }
    }

    private var darkModeView: some View {
        Toggle("", isOn: $viewModel.isLightMode)
            .toggleStyle(DarkModeToggleStyle())
            .padding(.trailing)
    }

    private var customizeListView: some View {
        HStack {
            alphabeticalView
            changeNumberOfResultsView
            Spacer()
        }
        .accentColor(.tintColor)
        .padding(.horizontal)
    }

    private var changeNumberOfResultsView: some View {
        Button("\(AppTexts.numberOfResults): \(viewModel.numberOfResults)") {
            viewModel.showResultOptions = true
        }
        .confirmationDialog(AppTexts.selectNumberOfResult, isPresented: $viewModel.showResultOptions, titleVisibility: .visible) {
            ForEach(NumberOfResults.allCases, id: \.self) { value in
                Button(value.rawValue.description) {
                    viewModel.updateUsers(number: value.rawValue)
                }
            }
        }

    }

    private var alphabeticalView: some View {
        Toggle(isOn: $viewModel.sortAlphabetically) {
            Text("A-Z").font(.callout).padding(4)
        }
        .toggleStyle(.button)
        .onChange(of: viewModel.sortAlphabetically) { viewModel.sortUsers(alphabetically: $0) }
    }

    private func initialSetup() {
        viewModel.initialSetup()
    }

    private func configureUserCell(with element: User, at index: Int) -> some View {
        UserCell(index: index, user: element, onEmailClick: {
            EmailService.shared.sendEmail(subject: "Greetings \(element.name.fullname())",
                                          body: "",
                                          to: [element.email]) { didWork in
                if !didWork {
                    viewModel.showAlert(with: AppTexts.couldNotSendEmail)
                }
            }
        }).redacted(reason: viewModel.isLoading ? .placeholder : .init())
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
