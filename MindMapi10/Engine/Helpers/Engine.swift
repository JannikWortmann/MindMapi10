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
        if let url  = URL(string: url) {
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
                let abstractLink = try item.getElementsByClass("abstract")
                
                let url = try titlesLink.attr("href")
                let title = try titlesLink.text()
                let author = try authorsLink.text()
                let abstract = try abstractLink.text()
                
                let pdfURL = getPDFLink(from: Constants.sharedInstance.acmCitationURL + url)
                
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
                        
                        if link.contains("author_page") {
                            papers = self.getData(from: link)
                        }
                    }

                }
            }
        } catch {
            
        }
        
        return papers
    }
    
    func getPDFLink(from link: String) -> String {
        let html = getHTML(for: link)
        
        do {
            let doc = try! SwiftSoup.parse(html)
            let pdfURL = try doc.body()?.getElementsByAttributeValue("name", "FullTextPDF").attr("href")
            
            return pdfURL!
        } catch {
            
        }
        
        return ""
    }
}
