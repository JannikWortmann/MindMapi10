//
//  Engine.swift
//  MindMap
//
//  Created by Orkhan Alizada on 18.12.17.
//  Copyright © 2017 Orkhan Alizada. All rights reserved.
//

import UIKit
import SwiftSoup

class Engine {
    static let shared = Engine()
    
    public func getData(from string: String) -> [TitlesObject] {
        let url = urlGenerator(from: string)
        let html = getHTML(for: url)

        return getTitlesAndLinks(from: html)
    }
    
    private func urlGenerator(from string: String) -> String {
        let generatedText = String(string.map { $0 == " " ? "+" : $0 })
        let url = Constants.sharedInstance.acmQueryURL + generatedText
        
        return url
    }
    
    private func getHTML(for url: String) -> String {
        let newURL = URL(string: url)
        
        do {
            let htmlString = try String(contentsOf: newURL!, encoding: .ascii)
            
            return htmlString
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        return ""
    }
    
    private func getTitlesAndLinks(from html: String) -> [TitlesObject] {
        var titles = [TitlesObject]()
        
        let doc = try! SwiftSoup.parse(html)
        
        do {
            let body = try doc.body()?.getElementsByClass("details")
            
            for item in body! {
                let titlesLink = try item.getElementsByClass("title").select("a")
                let authorsLink = try item.getElementsByClass("authors").select("a")
                let pdfLink = try item.getElementsByClass("ft").select("a")
                let abstractLink = try item.getElementsByClass("abstract")
                
                let url = try titlesLink.attr("href")
                let title = try titlesLink.text()
                let author = try authorsLink.text()
                let pdfURL = try pdfLink.attr("href")
                let abstract = try abstractLink.text()
                
                let newTitleObject = TitlesObject(title: title, author: author, link: url, abstract: abstract, pdfURL: Constants.sharedInstance.acmCitationURL + pdfURL)
                
                titles.append(newTitleObject)
            }
        } catch {
            
        }
        
        return titles
    }
    
    private func getReferences(from html: String) -> [String: String] {
        var titlesAndLinks = [String: String]()
        let doc = try! SwiftSoup.parse(html)
        
        do {
        let numberOfTries = try doc.getElementsByClass("mediumb-text").array().count
        
        for i in 0..<numberOfTries {
            let sectionTitle = try doc.getElementsByClass("mediumb-text").array()[i].text()
            
            if sectionTitle == "REFERENCES" {
                let references = try doc.getElementsByClass("flatbody").select("div").array()[i+1].select("tbody").select("a").array()
                
                for ref in references {
                    let link = try ref.attr("href")
                    let text = try ref.text()
                    
                    if link.contains("citation.cfm") {
                        print("Link: \(link)")
                        print("Text: \(text)")
                        
                        titlesAndLinks[link] = text
                    }
                }
            }
        }
        } catch {
            
        }
        
        return titlesAndLinks
    }
}
