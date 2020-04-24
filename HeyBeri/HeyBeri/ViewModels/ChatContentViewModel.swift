//
//  ChatContentViewModel.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit
import MessageKit

struct HMContentModel: Decodable {
    let user_id_send: String
    let user_id_receive: String?
    let time: String
    let content: String
}

struct ChatContentViewModel {
    let user: HMChatUser
    let chatContent: HMContentModel
}

extension ChatContentViewModel: MessageType {
    var sender: SenderType {
        return user
    }

    var messageId: String {
        return chatContent.user_id_send
    }

    var sentDate: Date {
        return Date.getDateBy(string: chatContent.time, format: "yyyy-MM-dd HH:mm:ss") ?? Date()
    }

    var kind: MessageKind {
        return .text(chatContent.content)
    }
}

struct HMChatUser: Decodable, Equatable {
    let id: String
    let name: String
}

extension HMChatUser: SenderType {
    var senderId: String {
        return id
    }

    var displayName: String {
        return name
    }

}
