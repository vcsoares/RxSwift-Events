//
//  ModelTests.swift
//  sicredi-testTests
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import Quick
import Nimble
@testable import sicredi_test

class ModelTests: QuickSpec {
    var rawJSON = #"""
    {
        "people": [],
        "date": 1534784400,
        "description": "O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade",
        "image": "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png",
        "longitude": -51.2146267,
        "latitude": -30.0392981,
        "price": 29.99,
        "title": "Feira de adoção de animais na Redenção",
        "id": "1"
    }
    """#
    
    override func spec() {
        describe("Model Instantiation") {
            context("WHEN a raw JSON object of an Event is received") {
                it("THEN an instance of Event is initialized from it") {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        let event = try decoder.decode(Event.self, from: self.rawJSON.data(using: .utf8)!)
                        
                        expect(event.id).to(equal("1"))
                        expect(event.title).to(equal("Feira de adoção de animais na Redenção"))
                        expect(event.date.timeIntervalSince1970).to(equal(1534784400))
                        expect(event.description).to(contain("O Patas Dadas estará na Redenção,"))
                        expect(event.image).to(equal("http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"))
                        expect(event.longitude).to(equal(-51.2146267))
                        expect(event.latitude).to(equal(-30.0392981))
                        expect(event.price).to(equal(29.99))
                        expect(event.people).to(beEmpty())
                    } catch {
                        fail("\(error)")
                    }
                }
            }
        }
    }
}
