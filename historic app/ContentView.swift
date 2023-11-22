import SwiftUI
import MapKit
//You should know

//IDK someone fill this in
struct MapView: UIViewRepresentable {
    @Binding var zoomInOut: Double
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    //Map details
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 1.2540, longitude: 103.8234)
        let span = MKCoordinateSpan(latitudeDelta: zoomInOut, longitudeDelta: zoomInOut)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Sentosa"
        uiView.addAnnotation(annotation)
    }
}

//Content view variables theyre name-explanatory
struct ContentView: View {
    @State private var showSheet = false
    @State private var sheetPosition: CGFloat = 0 // Initially on-screen
    @State private var selectedTab = 0
    @State private var textEntered = ""
    @State private var tabPos: CGFloat = 0
    //4 The var below, false is when the sheet is down
    @State private var chkShtTbPos = false
    
    
    @State private var isExpanded = false
    
    @State private var showFav = false
    @State private var zoomInOut = 0.001
    
    
    var body: some View {
        //Everything on screen starts here{
        
        ZStack {
            
            MapView(zoomInOut: $zoomInOut)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        HStack{
                            Button{
                                if zoomInOut > 0.0001{
                                    zoomInOut -= 0.001
                                }
                            }label: {
                                Image(systemName: "plus.magnifyingglass")
                                    .padding(10)
                            }
                            
                            HandleBar()
                                .frame(maxWidth: .infinity)
                                .background(.black.opacity(0.000001))
                            Spacer(minLength: 10)
                            Button{
                                if zoomInOut < 179.9999{
                                    zoomInOut += 0.001
                                }
                            }label: {
                                Image(systemName: "minus.magnifyingglass")
                                    .padding(10)
                            }
                        }
                        //DO NOT CHANGE WTV CODE IS FROM HERE{
                        .gesture(
                            DragGesture(coordinateSpace: .named("Geometry"))
                                .onChanged { value in
                                    // Update sheet position based on drag gesture
                                    sheetPosition = value.translation.height
                                }
                                .onEnded { value in
                                    
                                    // Determine whether to show or hide the sheet based on drag distance
                                    let threshold: CGFloat = -100
                                    
                                    //BTW you can edit the code but ONLY the one below if u understand whats going on wtv is above DO NOT TOUCH is the sheet movement code.
                                    
                                    //What happens when the sheet goes up
                                    
                                    withAnimation(.bouncy){ //only Xcode 15.0 has snappy animation, so yall will get an error. How to fix: get rid of "(.snappy)" yes the brackets too. Theres another one down at 3 paragraphs.
                                        
                                        chkShtTbPos = true
                                        if chkShtTbPos == true{
                                            isExpanded = true
                                            sheetPosition = 0
                                        }
                                    }
                                    if value.translation.height < threshold {
                                        withAnimation {
                                            // This controls how high the sheet goes up btw higher value decreases height 不要问
                                            showSheet = false
                                            
                                        }
                                    } else { // What happens when sheet goes down
                                        
                                        withAnimation(.smooth){
                                            //only Xcode 15.0 has snappy animation, so yall will get an error. How to fix: get rid of "(.snappy)" yes the brackets too
                                            
                                            chkShtTbPos = false
                                            if chkShtTbPos == false{
                                                isExpanded = false
                                                sheetPosition = 0
                                            }
                                        }
                                        
                                        withAnimation {
                                            sheetPosition = 0
                                            showSheet = true
                                        }
                                        
                                    }
                                }
                            
                        )// }TO HERE its basically a .gesture code with a super long parameter details inside
                        
                        //Creates the tab bar
                        TabView{
                            // This is shown when the home "Button" is clicked
                            CustomSheetView()// This is the sheets view like buttons
                            
                            //Creates the home button design
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }
                            FavouritesView()
                                .tabItem {
                                    Label("Favourites", systemImage: "star.fill")
                                    
                                }
                            
                        }
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Do nothing on drag to prevent tab movement
                            }
                        )
                    }
                    .background(Color(.systemBackground))
                    .frame(height: geometry.size.height * (isExpanded ? 1 : 0.5) - sheetPosition)
                }//Vstack ends here
            }
            .coordinateSpace(name: "Geometry")

            
            
        }
    }
    // and ends roughly somewhere here
}

//Edits everthing displayed on the sheet{
struct CustomSheetView: View {
    let names = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    let address = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    let imageNum = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    let historicalRelevance = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    let nMRT = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    let nSGBs = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    @State private var searchText = ""
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    VStack {
                        NavigationLink {
                            ScrollView{
                                Image("monkey")
                                
                                HStack {
                                     Text(name)
                                        .font(.system(size: 24))
                                        .bold()
                                    Text("200km")
                                        .font(.system(size: 12))
                                    Button {
                                        //placeholder text, its supposed to put the location into favourites
                                    } label: {
                                        Label(" ", systemImage: "heart.circle")
                                    }
                                }
                                HStack {
                                    Text(address[0])
                                        .font(.system(size: 17))
                                        .bold()
                                    Image(systemName: "location.circle.fill")
                                }
                                Text(historicalRelevance[0])
                                    .padding(80)
                                Text("Nearest MRT Station: one-north (CC23)")
                                Text("Nearest Bus Services: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10")
                                Spacer()
                            }
                        }
                        //FORBIDDEN TO TOUCH PLS DON'T
                    label: {
                        Text(name)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
            .searchable(text: $searchText)
            //Smart search
            var searchResults: [String] {
                if searchText.isEmpty {
                    return names
                } else {
                    return names.filter { $0.contains(searchText) }
                }
            }
        }
        
        
    }
    
}
//Its that little grey thing on top of the sheet
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
        //.preferredColorScheme(.dark)
    }
}
