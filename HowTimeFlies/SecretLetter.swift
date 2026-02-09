//
//  SecretLetter.swift
//  HowTimeFlies
//
//  Created by Ayyub Jose on 12/5/25.
//
import Foundation

struct SecretLetter : Identifiable , Hashable {
    let id =  UUID();
    let text : String;
    
    
}

let secretLetters : [SecretLetter] = [
    SecretLetter(text : " In the journey of life, love, and learning, these past two years have been deeply reflective for me. You came into my life and changed me in ways I didn't even know I needed. You've shown me a different, honest, grounding kind of love, and I'm grateful for that."),
    SecretLetter(text : "My beautiful strong woman, your care and passion for things lights me up, your ability to dream and envision. Focus on where you are in your journey of life , be prepared for the future but live for today. Deal with problems as they come, the fear of the unknown is pointless and weighty."),
    SecretLetter(text: "The heart is not like a box that gets filled up; it expands in size the more you love. Our hearts are ever growing")
]
