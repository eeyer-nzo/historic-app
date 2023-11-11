import SwiftUI

struct ContentView: View {
    @State private var showSheet = false

    var body: some View {
        VStack {
            Text("MAP")
                .font(.largeTitle)
                .padding()
                
            Button("Show Sheet") {
                // Toggle the showSheet state
                showSheet.toggle()
            }
            .padding()

            // Example of a sheet
            .sheet(isPresented: $showSheet) {
                Text("Sentosa!")
                    .padding()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
