//
//  LoveReason.swift
//  HowTimeFlies
//
//  Created by Ayyub Jose on 12/2/25.
//

import Foundation

struct LoveReason : Identifiable , Hashable {
    let id = UUID();
    let text: String
    let isSecret : Bool
    
}

let loveReasons: [LoveReason] = [
    LoveReason(text: "Your Optimisim and Attempt to Find Joy in The Lives Of Others.", isSecret: false),
    LoveReason(text: "Your excitement learning things and sharing.", isSecret: false),
    LoveReason(text: "You support and encourage me in ways i didnt undersatnd to appreciate.", isSecret: false),
    LoveReason(text: "Your refusal to just wear a different shirt.", isSecret: false),
    LoveReason(text: "Your beauty", isSecret: false),
    LoveReason(text: "Your sexyness.", isSecret: false),
    LoveReason(text: "The way you do that thing 😩.", isSecret: false),
    LoveReason(text: "Your ever constant reminders of how much you like Nella's Pizza.", isSecret: false),
    LoveReason(text: "Your smile is still my favorite part of any day.", isSecret: true),
    LoveReason(text: "You’ve shown me a version of love I didn’t know I needed.", isSecret: true) // secret
]
