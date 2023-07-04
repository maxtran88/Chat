//
//  AuthViewModel.swift
//  ChatFirestoreExample
//
//  Created by Alisa Mylnikova on 12.06.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import ExyteMediaPicker

class AuthViewModel: ObservableObject {

    func auth(nickname: String, avatar: Media?) {
        Firestore.firestore()
            .collection(Collection.users)
            .whereField("deviceId", isEqualTo: SessionManager.shared.deviceId)
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { [weak self] (snapshot, _) in
                if let id = snapshot?.documents.first?.documentID {
                    let user = User(id: id, name: nickname, avatarURL: nil, isCurrentUser: true)
                    SessionManager.shared.storeUser(user)
                } else {
                    self?.createNewUser(nickname: nickname, avatar: avatar)
                }
            }
    }

    func createNewUser(nickname: String, avatar: Media?) {
        Task {
            guard let avatarURL = await UploadingManager.uploadMedia(avatar) else { return }
            var ref: DocumentReference? = nil
            ref = Firestore.firestore()
                .collection(Collection.users).addDocument(data: [
                "deviceId": SessionManager.shared.deviceId,
                "nickname": nickname,
                "avatarURL": avatarURL.absoluteString
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else if let id = ref?.documentID {
                    let user = User(id: id, name: nickname, avatarURL: avatarURL, isCurrentUser: true)
                    SessionManager.shared.storeUser(user)
                }
            }
        }
    }
}