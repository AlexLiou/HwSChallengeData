//
//  ContentView.swift
//  HwSChallengeData
//
//  Created by Alex Liou on 5/9/22.
//

import SwiftUI

struct Response: Codable {
    var users: [User]
}

struct Friend: Identifiable, Codable {
    var id: UUID
    var name = ""
}

struct User: Identifiable, Codable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}

struct ContentView: View {
    @State private var users = [User]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink {
                        Text(user.name)
                    } label: {
                        VStack(alignment:.leading) {
                            Text(user.name)
                                .font(.headline)
                            HStack {
                                Image(systemName: "circle")
                                    .overlay(Circle()
                                        .fill(user.isActive ? .green : .gray)
                                    )
                                    
                                    
                                Text(user.isActive ? "Active" : "In Active")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .opacity(user.isActive ? 1 : 0.6)
                    
                    
                }
            }
            .task {
                await loadData()
            }
        }
        .ignoresSafeArea()
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else
            {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let userDecoder = JSONDecoder()
            
            userDecoder.dateDecodingStrategy = .iso8601
            
            do {
                users = try userDecoder.decode([User].self, from: data)
                return
            } catch {
                print("Decoding Failed: \(error)")
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
