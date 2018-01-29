//
//  Engine.swift
//  MindMap
//
//  Created by Orkhan Alizada on 18.12.17.
//  Copyright © 2017 Orkhan Alizada. All rights reserved.
//

import UIKit
import SwiftSoup

enum PaperType {
    case References
}

class Engine {
    static let shared = Engine()
    
    public func getData(from string: String) -> [Document] {
        let url = urlGenerator(from: string, for: nil)
        let html = getHTML(for: url)
        
        return getTitlesAndLinks(from: html)
    }
    
    private func urlGenerator(from string: String, for type: PaperType?) -> String {
        let generatedText = String(string.map { $0 == " " ? "+" : $0 })
        
        if let type = type, type == .References {
            return Constants.sharedInstance.acmCitationURL + generatedText
        } else {
            return Constants.sharedInstance.acmQueryURL + generatedText
        }
    }
    
    private func getHTML(for url: String) -> String {
        if let url = URL(string: url) {
            do {
                let htmlString = try String(contentsOf: url, encoding: .ascii)
                
                return htmlString
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
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
    
    private func getTitlesAndLinksForReference(from html: String) -> Document {
        let paper = Document()
        
        let doc = try! SwiftSoup.parse(html)
        
        do {
            if let title = try doc.body()?.getElementsByClass("large-text").array().first?.getElementsByTag("h1").text() {
                paper.title = title
            }
            
            if let pdf = try doc.body()?.getElementsByAttributeValue("name", "FullTextPDF").array(), pdf.count > 0 {
                let url = try pdf[0].attr("href")
                paper.pdf_url = Constants.sharedInstance.acmCitationURL + url
            }
            
            if let authors = try doc.body()?.getElementsByClass("medium-text").tagName("table").array(), authors.count > 0 {
                paper.author = try authors[2].getElementsByTag("tbody").text()
            }
        } catch {
            
        }
        
        return paper
    }
    
    public func getReferences(from url: String) -> [Document] {
        let url = url + "&preflayout=flat"
        let html = getHTML(for: url)
        
        var papers = [Document]()
        
        let doc = try! SwiftSoup.parse(html)
        
        do {
            let tables = try doc.getElementsByTag("table").array()
            
            for i in 0..<tables.count {
                let cellPadding = try tables[i].attr("cellpadding")
                if cellPadding == "5" {
                    let references = try tables[i].select("tbody").select("a").array()
                    
                    for ref in references {
                        let link = try ref.attr("href")
                        
                        if link.contains("citation.cfm?id=") {
//                            papers = self.getData(from: link, for: .References)
                            
                            let url = urlGenerator(from: link, for: .References)
                            let html = getHTML(for: url)
                            
                            let paper = getTitlesAndLinksForReference(from: html)
                            
                            papers.append(paper)
                        }
                    }
                }
            }
        } catch {
            
        }
        
        return papers
    }
}
