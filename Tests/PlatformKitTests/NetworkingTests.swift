//
//  Test.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/28/25.
//

import Testing
import Foundation
@testable import PlatformKit

struct NetworkingTests {

    let networking = NetworkingImpl()

    /**
     *  Demoing if we have separate BFF for the features.
     */
    let postBFFBase = "https://jsonplaceholder.typicode.com"
    let userBFFBase = "https://jsonplaceholder.typicode.com"
    let commentBFFBase = "https://jsonplaceholder.typicode.com"

    // MARK: - Fetch List

    @Test
    func fetchPostsList_success() async throws {
        let url = "\(postBFFBase)/posts"

        let posts = try await networking.fetchList(
            url: url,
            type: Post.self
        )

        #expect(!posts.isEmpty)
        #expect(posts.first?.id != nil)
    }
    
    @Test
    func fetchUsersList_success() async throws {
        let url = "\(userBFFBase)/users"

        let users = try await networking.fetchList(
            url: url,
            type: User.self
        )

        #expect(!users.isEmpty)
        #expect(users.first?.id != nil)
    }
    
    @Test
    func fetchCommentsList_success() async throws {
        let url = "\(commentBFFBase)/comments"

        let comments = try await networking.fetchList(
            url: url,
            type: Comment.self
        )

        #expect(!comments.isEmpty)
        #expect(comments.first?.id != nil)
    }

    // MARK: - Fetch Single

    @Test
    func fetchSinglePost_success() async throws {
        let url = "\(postBFFBase)/posts/1"

        let post = try await networking.fetchSingle(
            url: url,
            type: Post.self
        )

        #expect(post.id == 1)
        #expect(!post.title.isEmpty)
    }
    
    @Test
    func fetchSingleUser_success() async throws {
        let url = "\(userBFFBase)/users/1"

        let user = try await networking.fetchSingle(
            url: url,
            type: User.self
        )

        #expect(user.id == 1)
        #expect(!user.name.isEmpty)
    }
    
    @Test
    func fetchSingleComment_success() async throws {
        let url = "\(commentBFFBase)/comments/1"

        let comment = try await networking.fetchSingle(
            url: url,
            type: Comment.self
        )

        #expect(comment.id == 1)
        #expect(!comment.name.isEmpty)
    }

    // MARK: - Invalid URL

    @Test
    func fetchList_invalidURL_throws() async throws {
        let invalidURL = "not a url"

        await #expect(throws: URLError.self) {
            try await networking.fetchList(
                url: invalidURL,
                type: Post.self
            )
        }
    }

    // MARK: - Update Record

    @Test
    func updatePostRecord_success() async throws {
        let url = URL(string: "\(postBFFBase)/posts/1")!

        let updatedPost = Post(
            id: 1, userId: 1,
            title: "Updated Title",
            body: "Updated Body"
        )

        let result = try await networking.updateRecord(
            url: url,
            type: Post.self,
            record: updatedPost
        )

        #expect(result?.id == 1)
        #expect(result?.title == "Updated Title")
    }
    
    @Test
    func updateUserRecord_success() async throws {
        let url = URL(string: "\(userBFFBase)/users/1")!

        let updatedUser = User(
            id: 1,
            name: "Updated Name",
            username: "",
            address: Address(street: "", suite: "", city: "", zipcode: "", geo: Geo(lat: "", lng: "")),
            phone: "",
            website: "",
            company: Company(name: "", catchPhrase: "", bs: "")
        )

        let result = try await networking.updateRecord(
            url: url,
            type: User.self,
            record: updatedUser
        )

        #expect(result?.id == 1)
        #expect(result?.name == "Updated Name")
    }
    
    @Test
    func updateCommentRecord_success() async throws {
        let url = URL(string: "\(commentBFFBase)/comments/1")!

        let updatedComment = Comment(
            id: 1, postId: 1,
            name: "Updated Name",
            email: "",
            body: "Updated Body"
        )

        let result = try await networking.updateRecord(
            url: url,
            type: Comment.self,
            record: updatedComment
        )

        #expect(result?.id == 1)
        #expect(result?.name == "Updated Name")
    }

    // MARK: - Delete Record

    @Test
    func deletePostRecord_success() async throws {
        let url = URL(string: "\(postBFFBase)/posts")!

        try await networking.deleteRecord(
            url: url,
            type: Post.self,
            withID: 1
        )

        #expect(true)
    }
    
    @Test
    func deleteUserRecord_success() async throws {
        let url = URL(string: "\(userBFFBase)/users")!

        try await networking.deleteRecord(
            url: url,
            type: User.self,
            withID: 1
        )

        #expect(true)
    }
    
    @Test
    func deleteCommentRecord_success() async throws {
        let url = URL(string: "\(commentBFFBase)/comments")!

        try await networking.deleteRecord(
            url: url,
            type: Comment.self,
            withID: 1
        )

        #expect(true)
    }
}
