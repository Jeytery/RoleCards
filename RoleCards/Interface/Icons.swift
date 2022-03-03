//
//  Icons.swift
//  RoleCards
//
//  Created by Jeytery on 03.10.2021.
//

import UIKit

class Icons {
    
    private static func Icon(
        _ name: String,
        renderingMode: UIImage.RenderingMode = .alwaysTemplate
    ) -> UIImage {
        return UIImage(named: name)!.withRenderingMode(renderingMode)
    }
    
    static let vector = UIImage(named: "vector")!.withRenderingMode(.alwaysTemplate)
    static let lock = UIImage(named: "lock")!.withRenderingMode(.alwaysTemplate)
    static let noResults = UIImage(named: "noResults")!.withRenderingMode(.alwaysOriginal)
    
    static let tick = UIImage(named: "tick")!.withRenderingMode(.alwaysTemplate)
    static let edit = UIImage(named: "edit")!.withRenderingMode(.alwaysTemplate)
    static let cross = UIImage(named: "cross")!.withRenderingMode(.alwaysTemplate)
    static let social = UIImage(named: "social")!.withRenderingMode(.alwaysTemplate)
    static let play = UIImage(named: "play")!.withRenderingMode(.alwaysTemplate)
    static let cardBack = UIImage(named: "cardback")!.withRenderingMode(.alwaysOriginal)
    static let decks = UIImage(named: "decks")!.withRenderingMode(.alwaysTemplate)
    
    static let minus = Icon("minus")
    static let plus =  Icon("plus")
    
    static let addDeck = Icon("addDeck")
    static let addCard = Icon("addCard")
    
    static let trash = Icon("trash")
    
    static let shuffle = Icon("shuffle")
}

