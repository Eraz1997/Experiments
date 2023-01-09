/// The home page to select the experiments

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationStack {
      List {
        NavigationLink("API redirect") {
          ApiRedirectView()
        }
      }
      .padding()
      .navigationTitle("ENRS Experiments")
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
