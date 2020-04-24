//
//  HMChatBotVC.swift
//  VietApp
//
//  Created by NamNH-D1 on 8/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class HMChatBotVC: HMBaseChatVC {
    
    // MARK: - Variables
//    var model: HMChatModel!
    var userPhone: String!
//    private var viewModel: HMChatsViewModel!
    private var avatar: Avatar?
    private var isRecordingVoice = false
    
    // MARK: - Constants
    let outgoingAvatarOverlap: CGFloat = 17.5
    
    override func viewDidLoad() {
        sendMessage = { [weak self] message in
            guard let sSelf = self else { return }
            let parameters: [String: String] = ["user_id_send": "",
                                                "user_id_receive": "",
                                                "content": message,
            ]
            HMChatService.instance.sendMessage(parameters: parameters)
        }

        super.viewDidLoad()

        HMOneSignalNotificationService.shared.sendPush()
        HMTexToSpeechAPI(text: "hệ thống tổng hợp tiếng nói trung tâm không gian mạng").execute(target: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupView() {
        super.setupView()
        addLeftNavigationBarbutton()
        addRightNavigationBarbutton()
        setupSocket()

        HMSpeechRecognitionService.instance.didReceiveMessages = { [weak self] messages in
            self?.configureInputBarItems()
            self?.insertMessages(messages as [Any])
            self?.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func setupSocket() {
        HMChatService.instance.didLoadHistory = { historyList in
        }
        
        HMChatService.instance.socketDidConnect = {
        }
        
        HMChatService.instance.didReceiveTyping = {[weak self] text in
//            self?.setTypingIndicatorViewHidden(false)
        }
        
        HMChatService.instance.didReceiveMessage = {[weak self] message in
            guard let sSelf = self else { return }
//            if message.user.id == sSelf.model.user_id {
//                self?.insertMessage(message)
//                self?.setTypingIndicatorViewHidden(true, performUpdates: {
//                    self?.insertMessage(message)
//                })
//            }
        }
    }
    
    private func addLeftNavigationBarbutton() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: backView.frame)
        backButton.addTarget(self, action: #selector(invokeBackButton(_:)), for: .touchUpInside)
        
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 13, width: 13, height: 14))
        backImageView.image = UIImage(named: "icon_back")
        backView.addSubview(backImageView)
        backView.addSubview(backButton)
        let backItem = UIBarButtonItem.init(customView: backView)
        
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        avatarImageView.kf.setImage(with: model.userAvatarURL, placeholder: UIImage(named: "icon_avatar_placeholder"))
        avatarImageView.cornerRadius = 15
        avatar = Avatar(image: avatarImageView.image)
        let titleLB = UILabel(frame: CGRect(x: 34, y: 0, width: 160, height: 30))
//        titleLB.attributedText = NSMutableAttributedString(string: model.user_name, attributes: [
//            .font: UIFont.boldSystemFont(ofSize: 17.0),
//            .foregroundColor: UIColor.blueColor
//            ])
        titleView.addSubview(avatarImageView)
        titleView.addSubview(titleLB)
        
        let titleItem = UIBarButtonItem.init(customView: titleView)
        
        navigationItem.leftBarButtonItems = [backItem, titleItem]
    }
    
    private func addRightNavigationBarbutton() {
        let callView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let callButton = UIButton(frame: callView.frame)
        callButton.addTarget(self, action: #selector(invokeCallButton(_:)), for: .touchUpInside)
        
        let callImageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
        callImageView.image = UIImage(named: "icon_phone_d14b79")
        callView.addSubview(callImageView)
        callView.addSubview(callButton)
        let callItem = UIBarButtonItem.init(customView: callView)
        
        navigationItem.rightBarButtonItems = [callItem]
    }
    
    // MARK: - Action
    @objc private func invokeBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func invokeCallButton(_ sender: Any) {
        if !userPhone.phoneTrimming().isEmpty {
            guard let number = URL(string: "tel://" + userPhone.phoneTrimming()) else { return }
            UIApplication.shared.open(number)
        }
    }

    // MARK: - Configure message view
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        layout?.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .zero))
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        additionalBottomInset = 30
    }

    override func configureMessageInputBar() {
        super.configureMessageInputBar()
        messageInputBar.separatorLine.isHidden = false
        messageInputBar.separatorLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        messageInputBar.inputTextView.tintColor = sendColor
//        messageInputBar.inputTextView.backgroundColor = UIColor.chatboxBackground
        messageInputBar.inputTextView.placeholder = "Viết tin nhắn"
//        messageInputBar.inputTextView.placeholderTextColor = UIColor.grayColor
        messageInputBar.inputTextView.font = UIFont.systemFont(ofSize: 14.0)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 9, left: 20, bottom: 9, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 9, left: 20, bottom: 9, right: 36)
//        messageInputBar.inputTextView.layer.borderColor = UIColor.chatboxBorderColor.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 5.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.topStackViewPadding.top = 16
        messageInputBar.setRightStackViewWidthConstant(to: 80, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        messageInputBar.sendButton.setSize(CGSize(width: 40, height: 40), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "icon_send")
        messageInputBar.sendButton.title = ""
        messageInputBar.middleContentViewPadding.right = -80
        
        let speechButton = makeButton(named: "icon_micro", action: { [weak self] in
            self?.view.endEditing(true)
            // Check recording permission
            switch HMPermission.recordStatus {
            case .undetermined:
                HMPermission.requestRecordPermission(completion: { granted in
                    if granted {
                        self?.showRecordingPopup()
                    } else {
                        UIAlertController.showQuickSystemAlert(message: "access_micro_denied".localized)
                    }
                })
            case .granted:
                self?.showRecordingPopup()
            case .denied:
                UIAlertController.showQuickSystemAlert(message: "access_micro_denied".localized)
            default: break
            }
        })
        let bottomItems: [InputItem] = [speechButton, messageInputBar.sendButton]
        messageInputBar.setStackViewItems(bottomItems, forStack: .right, animated: false)
    }
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return true }
        return Date.minuteBetween(start: messageList[indexPath.section - 1].sentDate, end: messageList[indexPath.section].sentDate) > 15
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user.id == messageList[indexPath.section - 1].user.id
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user.id == messageList[indexPath.section + 1].user.id
    }
    
    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func makeButton(named: String, action: (() -> Void)?) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 40, height: 40), animated: false)
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onSelected {
                $0.tintColor = self.sendColor
            }.onDeselected {
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onTouchUpInside { _ in
                print("Item Tapped")
                action?()
        }
    }
    
    private func showRecordingPopup() {
        isRecordingVoice = true
        HMSpeechRecognitionService.instance.startRecording()
        let stopSpeechButton = makeButton(named: "icon_stop", action: { [weak self] in
            HMSpeechRecognitionService.instance.stopRecording(requestAPIAfterStop: true)
            self?.isRecordingVoice = false
        })
        let bottomItems: [InputItem] = [stopSpeechButton]
        messageInputBar.setStackViewItems(bottomItems, forStack: .right, animated: false)
    }
    
    // MARK: - MessagesDataSource
    
    override func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    override func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    override func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath == tappedIndexPath {
            return super.messageBottomLabelAttributedText(for: message, at: indexPath)
        }
        return nil
    }
}

extension HMChatBotVC: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
//        switch detector {
//        case .hashtag, .mention:
//            if isFromCurrentSender(message: message) {
//                return [.foregroundColor: UIColor.white]
//            } else {
//                return [.foregroundColor: UIColor.pinkColor]
//            }
//        default: return MessageLabel.defaultAttributes
//        }
        if isFromCurrentSender(message: message) {
            return [.foregroundColor: UIColor.white]
        } else {
            return [.foregroundColor: sendColor]
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? sendColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) || isTimeLabelVisible(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) || isTimeLabelVisible(at: IndexPath(row: 0, section: indexPath.section + 1)) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) || isTimeLabelVisible(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) || isTimeLabelVisible(at: IndexPath(row: 0, section: indexPath.section + 1)) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let avatar = avatar else { return }
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        
        let shouldShow = Int.random(in: 0...10) == 0
        guard shouldShow else { return }
        
        let button = UIButton(type: .infoLight)
        button.tintColor = sendColor
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = sendColor.withAlphaComponent(0.3)
    }
    
    // MARK: - Audio Messages
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return self.isFromCurrentSender(message: message) ? .white : sendColor
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
    
}

// MARK: - MessagesLayoutDelegate

extension HMChatBotVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath == tappedIndexPath ? 16 : 0
    }
    
}
