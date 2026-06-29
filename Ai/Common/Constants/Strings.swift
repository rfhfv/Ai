//
//  Strings.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

enum Strings {
    
    enum Main {
        static let mainTitle = "Your AI tools,\n ready to go"
        static let searchPlaceholder = "Ask anything..."
        
        static let fixCardTitle = "Fix & Improve\nWriting"
        static let fixCardSubtitle = "Rewrite • Fix grammar"
        
        static let SummarizeCardTitle = "Understand\nFaster"
        static let SummarizeCardSubtitle = "Summarize • Key points"
        
        static let videoTitle = "Turn Photo\ninto Video"
        static let videoSubtitle = "Animate • Templates"
        static let videoButton = "Ready in seconds"
    }
    
    enum Chat {
        static let chatId = "current_chat_id"
        static let aiChatTitle = "AI Chat"
        static let dateTitle = "26.03.2026"
        static let title = "Your AI assistant for anything"
        static let subtitle = "Ask questions, get answers, and explore ideas\nin seconds"
        static let placeholder = "How can I help you?"
        static let askPlaceholder = "Ask anything..."
        static let errorText = "Что-то пошло не так. Попробуй ещё раз."
    }
    
    
    enum ChatHistory {
        static let title = "AI Chat History"
        static let emptyTitle = "No chats yet"
        static let emptySubtitle = "Start a conversation to see\nyour history here"
    }
    
    enum Video {
        static let title = "AI Video"
        static let previewTitle = "Title"
        static let alertTitle = "Allow access to photos?"
        static let alertMessage = "To upload an image, the app needs access to your photo gallery."
        static let cancelText = "Cancel"
        static let allowText = "Allow"
    }
    
    enum Generation {
        static let createText = "Create"
    }
    
    enum Result {
        static let title = "Result"
        static let generationTitle = "Generating..."
        static let generationSubTitle = "We're creating the best result for you"
        static let replaceText = "Replace"
        static let shareText = "Share"
        static let downloadText = "Download"
        static let saveVideoText = "Video has been saved\nto your gallery"
    }
    
    enum Paywall {
        static let title = "Create anything\nyou want"
        static let starsSubtitle = "Get results in seconds"
        static let textSubtitle = "Turn any text into better writing"
        static let infoSubtitle = "Simplify complex information"
        static let contentSubtitle = "Create content with AI templates"
        static let cancelTitle = "⊘ Cancel Anytime"
        static let unlockNowText = "Unlock now"
        static let errorTitle = "Error"
        static let okTitle = "Ok"
        static let subscriptionsNotFoundText = "No active subscriptions found."
        static let privacyPolicyText = "Privacy Policy"
        static let restorePurchasesText = "Restore Purchases"
        static let termsOfUseText = "Terms of Use"
        static let saveSaleText = "SAVE 80%"
        static let privacyUrlText = "https://some-privacy-url.com"
        static let termsUrlText = "https://some-terms-url.com"
    }
}
