//
//  UserlistViewModel.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import SwiftUI
import Combine
extension UserListView  {

    @MainActor class ViewModel: ObservableObject {
        @Published  private(set) var cancellables: Set<AnyCancellable> = []

        @Published private(set) var userResults: UserResults?
        @Published private(set) var orignalResults: UserResults?
        @Published private(set) var numberOfResults = 20

        @Published var isLoading = true
        @Published var isLightMode = false
        @Published var sortAlphabetically = false
        @Published var showResultOptions = false
        @Published var alertParameters: AlertParameters?
        
        @Environment(\.colorScheme) var deviceColorScheme: ColorScheme

        func initialSetup() {
            self.isLightMode = deviceColorScheme == .light
            self.fetchUserLists()
        }

        func fetchUserLists() {
            isLoading = true
            let parameters: [String: String] = ["results": numberOfResults.description]

            Network
                .init(router: UserRouter.getUsers(queryParameter: parameters))
                .request()
                .map { ($0.value as UserResults) }
                .sink(receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self.alertParameters = AlertParameters(message: error.localizedDescription)
                    case .finished: break
                    }
                }, receiveValue: { response in
                    self.userResults = response
                    self.orignalResults = response
                    self.sortUsers(alphabetically: self.sortAlphabetically)
                })
                .store(in: &self.cancellables)
        }

        func sortUsers(alphabetically: Bool) {
            if let users = userResults?.results {
                let sortedUsers = users.sorted(by: { $0.name.first < $1.name.first })
                userResults = alphabetically ? UserResults(results: sortedUsers, info: userResults!.info) : orignalResults
            }
        }

        func updateUsers(number: Int) {
            numberOfResults = number
            fetchUserLists()
        }

        func showAlert(with message: String) {
            alertParameters = AlertParameters(message: message)
        }
    }
}

