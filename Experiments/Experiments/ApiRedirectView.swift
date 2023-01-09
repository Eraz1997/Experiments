/// This view helps you test whether 302 redirects with Cloud Armor still make API work or they break.

import SwiftUI
import Alamofire

@MainActor class ViewModel: ObservableObject {
  @Published var method: HTTPMethod = .get
  @Published var url = ""
  @Published var statusCode: Int? = nil
  @Published var response: String? = nil

  var statusCodeText: String {
    guard let statusCode else {
      return "Send a request"
    }
    return "Status code \(statusCode)"
  }

  func sendRequest() {
    AF.request(URL(string: self.url)!, method: self.method)
      .response { response in
        self.statusCode = response.response?.statusCode
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.statusCode = nil
        }
        if let data = try? response.result.get() {
          self.response = String(data: data, encoding: .utf8)
        }
      }
  }
}

struct ApiRedirectView: View {
  @StateObject private var model = ViewModel()

  var body: some View {
    VStack {
      TextField("URL 🌐", text: self.$model.url)
        .textFieldStyle(.roundedBorder)
      Picker("Method", selection: self.$model.method) {
        Text("GET").tag(HTTPMethod.get)
        Text("POST").tag(HTTPMethod.post)
      }
      Button("Send") {
        self.model.sendRequest()
      }
      Text(self.model.statusCodeText)
        .font(.headline)
      Text(self.model.response ?? "")
    }
    .padding()
    .navigationTitle("API redirect tester")
  }
}

struct ApiRedirectView_Previews: PreviewProvider {
  static var previews: some View {
    ApiRedirectView()
  }
}
