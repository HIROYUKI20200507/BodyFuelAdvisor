//
//  ChatGPTService.swift
//  BodyFuelAdvisor
//
//  Created by 秋本 裕之 on 2023/04/08.
//

import Foundation

class ChatGPTService {
    private let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private let apiUrl: String = "https://api.openai.com/v1/engines/davinci-codex/completions"
    
    func getFeedback(weight: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: apiUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "人が入力した体重は\(weight)kgです。フィードバックを提供してください。"
        
        let requestData: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 50,
            "n": 1,
            "stop": ["\n"]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = jsonResponse["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let text = firstChoice["text"] as? String {
                        completion(.success(text.trimmingCharacters(in: .whitespacesAndNewlines)))
                    } else {
                        completion(.failure(NSError(domain: "com.example.chatgptapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
