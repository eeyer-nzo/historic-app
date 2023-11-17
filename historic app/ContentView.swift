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
    @State private var sheetPosition: CGFloat = UIScreen.main.bounds.height // Initially off-screen

    var body: some View {
        VStack(spacing: 0) {
            MapView()
                .edgesIgnoringSafeArea(.all) // Ignore safe area edges
                .frame(maxWidth: 400, maxHeight: 400)
                //.offset(y: -sheetPosition) // Adjust the top offset

            // Swipe-up gesture to show the sheet
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        sheetPosition = 0 // Bring the sheet on-screen
                        showSheet = true
                    }
                }

            Spacer() // Move the rest of the content to the bottom
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Update sheet position based on drag gesture
                    sheetPosition = max(min(value.translation.height, 0), -UIScreen.main.bounds.height)
                }
                .onEnded { value in
                    // Determine whether to show or hide the sheet based on drag distance
                    let threshold: CGFloat = -50
                    if value.translation.height < threshold {
                        withAnimation {
                            sheetPosition = -UIScreen.main.bounds.height
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
        .edgesIgnoringSafeArea(.top) // Ignore safe area edges for the VStack

        // Example of a sheet
        .overlay(
            CustomSheetView()
                .offset(y: sheetPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Update sheet position based on drag gesture
                            sheetPosition = max(min(value.translation.height, 0), -UIScreen.main.bounds.height)
                        }
                        .onEnded { value in
                            // Determine whether to show or hide the sheet based on drag distance
                            let threshold: CGFloat = -50
                            if value.translation.height < threshold {
                                withAnimation {
                                    sheetPosition = -UIScreen.main.bounds.height
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
        )
    }
}

struct CustomSheetView: View {
    var body: some View {
        VStack {
            HandleBar()
            Text("Swipe up to dismiss")
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
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
