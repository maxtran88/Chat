//
//  Created by Alex.M on 20.06.2022.
//

import Foundation
import Combine

public typealias ChatPaginationClosure = (Message) -> Void

final class ChatViewModel: ObservableObject {
    @Published private(set) var fullscreenAttachmentItem: Optional<any Attachment> = nil
    @Published var fullscreenAttachmentPresented = false

    private var subscriptions = Set<AnyCancellable>()
    
    func presentAttachmentFullScreen(_ attachment: any Attachment) {
        fullscreenAttachmentItem = attachment
        fullscreenAttachmentPresented = true
    }
    
    func dismissAttachmentFullScreen() {
        fullscreenAttachmentPresented = false
        fullscreenAttachmentItem = nil
    }
}