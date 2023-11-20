import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
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
    @State private var sheetPosition: CGFloat = 0 // Initially on-screen
    @State private var selectedTab = 0
    @State private var textEntered = ""

    var body: some View {
        ZStack {
            MapView()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HandleBar()
                    .frame(maxWidth: .infinity)
                    .background(.black.opacity(0.000001))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Update sheet position based on drag gesture
                                withAnimation {
                                    sheetPosition = max(min(value.translation.height, 0), -UIScreen.main.bounds.height)
                                }
                            }
                            .onEnded { value in
                                // Determine whether to show or hide the sheet based on drag distance
                                let threshold: CGFloat = -100
                                if value.translation.height < threshold {
                                    withAnimation {
                                        // This makes the sheet disappear
                                        sheetPosition = -UIScreen.main.bounds.height + 525
                                        showSheet = false
                                    }
                                } else {
                                    withAnimation {
                                        sheetPosition = 0
                                        showSheet = true
                                    }
                                }
                            }
                    )
                
                NavigationStack {
                    CustomSheetView()
                        .navigationTitle("Locations")

                }
            }
            .background(Color(.systemBackground))
            .offset(y: sheetPosition + 50 + 300)
        }
    }
}

struct CustomSheetView: View {
    @State private var textEntered = ""
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 10) {
                ForEach(1..<5) { index in
                    Button(action: {
                        // Action for Button \(index)
                    }) {
                        Text("Button \(index)")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $textEntered, prompt: Text("Search Locations"))
    }
}

struct HandleBar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 5)
            .foregroundColor(Color.gray)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
