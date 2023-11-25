import MapKit
import SwiftUI

//You should know

//IDK someone fill this in
struct MapView: UIViewRepresentable {
    @Binding var zoomInOut: Double
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    //Map details
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        for location in loadData() {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpan(latitudeDelta: zoomInOut, longitudeDelta: zoomInOut)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            uiView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.name
            uiView.addAnnotation(annotation)
        }
        
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
    @State var favLocations = ["Fort Canning Park", "Fort Siloso", "Old Changi Hospital", "National Museum"]
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
                                    let threshold: CGFloat = -50
                                    
                                    //BTW you can edit the code but ONLY the one below if u understand whats going on wtv is above DO NOT TOUCH is the sheet movement code.
                                    
                                    //What happens when the sheet goes up
                                    
                                   withAnimation(.smooth){
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
                                            
                                            chkShtTbPos = false
                                            if chkShtTbPos == false{
                                                isExpanded = false
                                                sheetPosition = 0
                                            }
                                        }
                                        
                                        
                                        sheetPosition = 0
                                        showSheet = true
                                    }
                                    
                                })// }TO HERE its basically a .gesture code with a super long parameter details inside
                        
                        //Creates the tab bar
                        TabView{
                            // This is shown when the home "Button" is clicked
                            CustomSheetView()// This is the sheets view like buttons
                            
                            //Creates the home button design
                                .tabItem {
                                    Label("Home", systemImage: "house")
                                }
                            FavouritesView(areas: $favLocations)
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
        .onAppear {
            loadData()
        }
    }
    // and ends roughly somewhere here
    
}
//Edits everthing displayed on the sheet{
struct CustomSheetView: View {
    let placeStory = loadData()
    @State private var searchText = ""
    
    func showImage(for place: Location) -> some View {
            AsyncImage(url: URL(string: place.imageUrl)!) { phase in
                switch phase {
                case .empty:
                    // Placeholder or loading view
                    Text("Loading...")
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(let error):
                    // Placeholder or error view
                    Text("Failed to load image: \(error.localizedDescription)")
                @unknown default:
                    // Placeholder or default view
                    Text("Unknown state")
                }
            }
        }
    
    func smartSearch() -> [Location] {
            if searchText.isEmpty {
                return placeStory
            } else {
                return placeStory.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    
    var body: some View {
        NavigationStack {
            List {
                let results = smartSearch()
                ForEach(results, id: \.name) { place in
                    VStack {
                        NavigationLink {
                            ScrollView {
                                showImage(for: place)
                                //Anything under the pic
                                HStack {
                                    Text(place.name)
                                        .font(.system(size: 20))
                                        .bold()
                                        .padding(12)
                                    Button{
                                        if let selectedPlace = results.first(where: { $0.name == place.name }) {
                                                favLocations.append(selectedPlace.name)
                                            }
                                        
                                    }label: {
                                        Image(systemName: "heart.circle")
                                            .padding(-8)
                                    }
                                    Spacer()
                                }
                                
                                VStack {
                                    if place.address != place.locationDetails{
                                    
                                        if place.address != "" && place.postalCode != ""{
                                            HStack{           Text(place.address + " (" + place.postalCode + ")")
                                                    .bold()
                                                    .padding(12)
                                                Spacer()
                                            }
                                            
                                            HStack {
                                                Spacer(minLength: 4)
                                                Text(place.locationDetails)
                                                    .multilineTextAlignment(.leading)
                                                .bold()
                                                Spacer()
                                                
                                            }
                                    }else if place.address != ""{
                                        Text(place.address)
                                            .bold()
                                            .padding(12)
                                    }else if place.postalCode != ""{
                                        Text(place.postalCode)
                                            .bold()
                                            .padding(12)
                                        }
                                    }
                                }
                                
                                Spacer(minLength: 40)
                                Text(place.description)
                                    .multilineTextAlignment(.leading)
                                    .padding(20)
                                Text("Nearest Bus Services: \(place.nearbyBus)")
                                                                    .padding(20)
                                                                Text("Nearest MRT: \(place.nearbyMRT)")
                                                                    .padding(20)
                                Button{
                                    if let url = URL(string: place.website) {
                                        UIApplication.shared.open(url)
                                    }
                                }label:{
                                    Text("Find out more")
                                }
                                
                            }
                        } label: {
                            // The label of the NavigationLink
                            Text(place.name)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
            .searchable(text: $searchText)
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

