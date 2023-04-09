import Foundation

enum ChatGPTAPIError: Error {
    case invalidResponse
    case noData
    case failedRequest
}

class ChatGPTAPI {
    private let apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private let apiUrl = "https://api.openai.com/v1/engines/davinci/completions"

    func getFeedback(forWeight weight: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = "体重が\(weight)kgの人に対するフィードバックを提供してください。"

        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 50,
            "temperature": 0.5,
            "top_p": 1
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        print(request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ChatGPTAPIError.noData))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(ChatGPTAPIError.invalidResponse))
                return
            }

            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let choices = jsonResult?["choices"] as? [[String: Any]], let firstChoice = choices.first, let text = firstChoice["text"] as? String {
                    completion(.success(text.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(ChatGPTAPIError.failedRequest))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
