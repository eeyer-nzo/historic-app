import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Your existing code for updating the map view
    }
}

struct ContentView: View {
    @State private var showSheet = false
    @State private var sheetPosition: CGFloat = 0 // Initially on-screen
    @State private var textEntered = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MapView()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: 600, maxHeight: 600)

                Rectangle()
                    .size(CGSize(width: 500.0, height: 1300.0))
                    .offset(y: sheetPosition + 50)
                    .fill(Color.blue)
                    .frame(maxWidth: .infinity, maxHeight: 1000, alignment: .center)

                // LazyVGrid for buttons
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 10) {
                    NavigationLink(destination: Text("Button 1 Destination")) {
                        Button {
                            // Action for Button 1
                        } label: {
                            Text("Button 1")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }

                    NavigationLink(destination: Text("Button 2 Destination")) {
                        Button {
                            // Action for Button 2
                        } label: {
                            Text("Button 2")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    
                    NavigationLink(destination: Text("Button 3 Destination")) {
                        Button {
                            // Action for Button 3
                        } label: {
                            Text("Button 3")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    
                    NavigationLink(destination: Text("Button 4 Destination")) {
                        Button {
                            // Action for Button 4
                        } label: {
                            Text("Button 4")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }

                    // Add more buttons as needed
                }
                .offset(y: sheetPosition)

                Spacer()
            }
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
                        let threshold: CGFloat = -50
                        if value.translation.height < threshold {
                            withAnimation {
                                sheetPosition = 0
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
            .edgesIgnoringSafeArea(.top)
            .overlay(
                CustomSheetView(textEntered: $textEntered)
                    .offset(y: sheetPosition)
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
            )
        }
    }
}

// Extracted CustomSheetView to a separate view structure
struct CustomSheetView: View {
    @Binding var textEntered: String

    var body: some View {
        VStack {
            HandleBar()
            TextField("Location", text: $textEntered)
                .textFieldStyle(.roundedBorder)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
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
