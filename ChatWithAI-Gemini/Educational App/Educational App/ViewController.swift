//
//  ViewController.swift
//  Educational App
//
//  Created by Ram Kumar on 26/06/24.
//

import UIKit
import GoogleGenerativeAI

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var queryTV: UITextView!
    @IBOutlet weak var resultTV: UITextView!
    @IBOutlet weak var logoImage: UIImageView!
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: "xxxxxxxxxxx")
    var responseValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        queryTV.returnKeyType = .done
        
        self.queryTV.layer.borderColor = UIColor.darkGray.cgColor
              self.queryTV.layer.borderWidth = 2
        
        self.resultTV.layer.borderColor = UIColor.darkGray.cgColor
              self.resultTV.layer.borderWidth = 2
    }
    
    // The purpose of this function is to handle the Enter key press event.
    // Handles the generation of an AIResponse and updates the text view accordingly.
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)  -> Bool {
            
        if text == "\n" {
            print("Enter Key Pressed")
            if !queryTV.text.isEmpty {
                let text = queryTV.text ?? ""
                generateResponse(text) { response in
                    self.responseValue = response
                    print("The response is \(response)")
                    DispatchQueue.main.async {
                        self.resultTV.text = response
                    }
                }
            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Generates a response based on the provided prompt.
    func generateResponse(_ prompt: String, completion: @escaping (String) -> Void) {
        Task {
            do {
            var responseData = try await model.generateContent(prompt)
                let responseText = responseData.text ?? "No Data Found"
                completion(responseText)
            } catch {
                completion("Something went wrong \n \(error.localizedDescription)")
            }
        }
    }
}

