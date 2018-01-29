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
    
    public func getData(from string: String) -> [Document] {
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
    
    private func getTitlesAndLinks(from html: String) -> [Document] {
        var papers = [Document]()
        
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
                
                let newObject = Document()
                newObject.title = title
                newObject.abstract = abstract
                newObject.author = author
                newObject.url = url
                newObject.pdf_url = Constants.sharedInstance.acmCitationURL + pdfURL
                
                papers.append(newObject)
            }
        } catch {
            
        }
        
        return papers
    }
    
    public func getReferences(from url: String) -> [Document] {
        let url = urlGenerator(from: url + "&preflayout=flat")
        let html = getHTML(for: url)
        
        var papers = [Document]()
        
        let doc = try! SwiftSoup.parse(html)
        
        do {
            let numberOfTries = try doc.getElementsByClass("mediumb-text").array().count
            
            for i in 0..<numberOfTries {
                let sectionTitle = try doc.getElementsByClass("mediumb-text").array()[i].text()
                
                if sectionTitle == "REFERENCES" {
                    let references = try doc.getElementsByClass("flatbody").select("div").array()[i-1].select("tbody").select("a").array()
                    
                    for ref in references {
                        let link = try ref.attr("href")
                        
                        if link.contains("citation.cfm") {
                            papers = self.getData(from: link)
                        }
                    }
                }
            }
        } catch {
            
        }
        
        return papers
    }
}
