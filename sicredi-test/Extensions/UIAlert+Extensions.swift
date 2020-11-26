//
//  UIAlert+Extensions.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 26/11/20.
//

import Foundation
import UIKit

extension UIAlertController {
    
    /// errorAlert(completionHandler:)
    /// Presents a preformatted error alert, with an optional completion handler.
    /// - Parameter completionHandler: action to be executed on alert dismissal
    /// - Returns: a preformatted alert controller
    static func errorAlert(completionHandler: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(
            title: "Algo deu errado!",
            message: "Não foi possível carregar os dados solicitados.",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Tentar novamente",
                style: .default,
                handler: { _ in
                    completionHandler?()
                }
            )
        )
        
        return alert
    }
    
    // Syntax candy for displaying a simple message as an alert
    static func message(_ message: String) -> UIAlertController {
        return UIAlertController(title: message, message: nil, preferredStyle: .alert)
    }

}
