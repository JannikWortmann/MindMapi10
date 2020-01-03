//
//  Engine.swift
//  MindMap
//
//  Created by Orkhan Alizada on 18.12.17.
//  Copyright © 2017 Orkhan Alizada. All rights reserved.
//

import UIKit
import SwiftSoup

// Enum to distinguish if it's a Reference or a Paper
// Paper if no PaperType set
enum PaperType {
    case References
}

class Engine {
    // Singletone for Engine to work with only one copy of it
    static let shared = Engine()
    
    // Method which allows to get easily all Titles(Document)
    // after the search process and display them later on
    public func getData(from string: String) -> [Document] {
        let url = urlGenerator(from: string, for: nil)
        let html = getHTML(for: url)
        
        return getTitlesAndLinks(from: html)
    }
    
    // Generates a URL from typed keywords in the SearchBar
    private func urlGenerator(from string: String, for type: PaperType?) -> String {
        let generatedText = String(string.map { $0 == " " ? "+" : $0 })
        
        // Take different URLs from Constants depending on the type
        // of request. If we are looking for references then use
        // `acmCitationURL`, otherwise `acmQueryURL`
        if let type = type, type == .References {
            return Constants.sharedInstance.acmCitationURL + generatedText
        } else {
            return Constants.sharedInstance.acmQueryURL + generatedText
        }
    }
    
    // Gets whole HTML code from the given URL
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
    
    // Parse given HTML to get from there all required data
    // `Titles`, `URL`, `PDF Link`, etc.
    // with the help of 3rd party framework `SwiftSoup`
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
    
    // If we are looking for only references of the paper
    // then we call this method.
    // It parses the given HTML to get from there
    // `Title`, `Authors` and `PDF Link`
    private func getTitlesAndLinksForReference(from html: String) -> Document? {
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
        
        if paper.title != "" {
            return paper
        } else {
            return nil
        }
    }
    
    // Method which gets all references from the given paper
    // and return it as array
    // We will send the data what we get from here to the method
    // `getTitlesAndLinksForReference` to get all required data
    // described above
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
                            let url = urlGenerator(from: link, for: .References)
                            let html = getHTML(for: url)
                            
                            // Here we get URL for each reference of the paper
                            // get HTML from that URL and pass as a parameter
                            // to the `getTitlesAndLinksForReference` method and from there we will get all required data
                            if let paper = getTitlesAndLinksForReference(from: html) {
                                
                                papers.append(paper)
                            }
                        }
                    }
                    
                    break
                }
            }
        } catch {
            
        }
        
        return papers
    }
}
