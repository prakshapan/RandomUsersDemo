//
//  UserCell.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import SwiftUI

struct UserCell: View {
    var index: Int
    var user: User
    var onEmailClick: () -> Void

    var body: some View {
        ZStack {
            cellBackgroundColor.padding(.horizontal, -16)
            VStack {
                HStack {
                    userImage.padding(.horizontal)
                    userDescription
                    Spacer()
                }.frame(minHeight: 100)
                Divider()
            }
        }
    }

    var userDescription: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name.fullname()).font(.title3)
            Text(user.email)
                .font(.callout)
                .foregroundColor(.gray)
                .onTapGesture(perform: onEmailClick)
        }
    }

    private var userImage: some View {
        AsyncImage(url: URL(string: user.picture.medium)) { phase in
            switch phase {
            case let .success(image):
                setUser(image: image)
            case .failure:
                setUser(image: Image.person)
            case .empty:
                setUser(image: Image.person).redacted(reason: .placeholder)
            @unknown default:
                EmptyView()
            }
        }
    }

    private var cellBackgroundColor: Color {
        index % 2 == 0 ? Color.cellAltenateBackground : .cellBackground
    }

    func setUser(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(35)
            .frame(width: 70, height: 70)
            .background(
                Circle()
                    .fill(Color.clear)
                    .frame(width: 80, height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.tintColor, lineWidth: 1.5))
            )
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(index: 1, user: User(gender: "", name: .mockName, email: "1", picture: .mockPicture), onEmailClick: {})
    }
}
