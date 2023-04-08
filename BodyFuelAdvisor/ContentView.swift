import SwiftUI
import Combine

struct ContentView: View {
    @State private var weightInput: String = ""
    @State private var feedback: String = ""
    private let chatGPTAPI = ChatGPTAPI()
    
    var body: some View {
        VStack {
            TextField("体重を入力してください", text: $weightInput)
                .padding()
                .keyboardType(.decimalPad)
            
            Button(action: getFeedback) {
                Text("フィードバックを取得")
            }
            .padding()
            
            Text(feedback)
                .padding()
        }
    }
    
    func getFeedback() {
        guard let weight = Double(weightInput) else {
            self.feedback = "無効な入力です。体重を正しく入力してください。"
            return
        }
        
        chatGPTAPI.getFeedback(forWeight: weight) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feedback):
                    self.feedback = feedback
                case .failure(let error):
                    self.feedback = "エラー: \(error.localizedDescription)"
                }
            }
        }
    }
}
