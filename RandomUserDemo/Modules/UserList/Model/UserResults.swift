//
//  Users.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//
import Foundation

// MARK: - Users

struct UserResults: Codable {
    let results: [User]
    let info: Info
}

// MARK: - Info

struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result

struct User: Codable, Hashable {
    let gender: String
    let name: Name
    let email: String
    let picture: Picture

    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
}

// MARK: - Name

struct Name: Codable {
    let title, first, last: String
    func fullname() -> String {
        title + ". " + first + " " + last
    }
}

extension Name {
    static var mockName: Self {
        Name(title: "Mr.", first: "First Name", last: "Last Name")
    }
}

// MARK: - Picture

struct Picture: Codable {
    let large, medium, thumbnail: String
}

extension Picture {
    static var mockPicture: Self {
        Picture(large: "", medium: "", thumbnail: "")
    }
}

extension UserResults {
    static var mockUsers = [
        User(gender: "", name: .mockName, email: "1", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "2", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "3", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "4", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "5", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "6", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "7", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "8", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "9", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "10", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "11", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "12", picture: .mockPicture),
        User(gender: "", name: .mockName, email: "13", picture: .mockPicture)
    ]
}
