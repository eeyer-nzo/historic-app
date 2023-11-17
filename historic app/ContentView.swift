import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // You can customize the map view here if needed
        let coordinate = CLLocationCoordinate2D(latitude: 1.2540, longitude: 103.8234)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Sentosa"
        uiView.addAnnotation(annotation)
    }
}

struct ContentView: View {
    @State private var showSheet = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                MapView()
                    .edgesIgnoringSafeArea(.all) // Ignore safe area edges
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: -geometry.safeAreaInsets.top) // Adjust the top offset

                Spacer() // Move the rest of the content to the bottom

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
        }
        .edgesIgnoringSafeArea(.top) // Ignore safe area edges for the VStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
