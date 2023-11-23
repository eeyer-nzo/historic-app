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
                                        
                                        withAnimation(){
                                            //only Xcode 15.0 has snappy animation, so yall will get an error. How to fix: get rid of "(.snappy)" yes the brackets too
                                            
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
    let placeStory = [
        placeInformation(calling: "Raffles Girls School ", details: "Raffles Girls' School began in 1844 as a girls' department in Singapore Institution (today Raffles Institution), and became independent in 1879. It was located here from 1928 to 1979", streetName: "Stamford Road", address: "Junction of Stamford Road and Armenian Street, beside Lee Kong Chian School of Business, Singapore Management University", postalCode: "178899", findWeb: "https://www.roots.gov.sg/places/places-landing/Places/historic-sites/raffles-girls-school", placePic: "https://roots.sg/~/media/Roots/Images/historic-sites/068-raffles-girls-school/068rafflesgirlsschool.png"),
        placeInformation(calling: "Singapore Chinese Girls' School", details: "Singapore Chinese Girls' School began in 1899 at Hill Street. It was founded by Straits Chinese pioneers to provide quality education for girls. The school was located here from 1925 to 1994.", streetName: "Emerald Hill Road", address: "", postalCode: "229313", findWeb: "https://www.roots.gov.sg/places/places-landing/Places/historic-sites/singapore-chinese-girls-school", placePic: "https://roots.sg/~/media/Roots/Images/historic-sites/080-singapore-chinese-girls-school/080singaporechinesegirlsschool.png")
    ]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.calling) { place in
                    VStack {
                        NavigationLink {
                            ScrollView {
                                AsyncImage(url: URL(string: place.placePic)!) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder or loading view
                                        Text("Loading...")
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure:
                                        // Placeholder or error view
                                        Text("Failed to load image")
                                    @unknown default:
                                        // Placeholder or default view
                                        Text("Unknown state")
                                    }
                                }
                                
                                //Anything under the pic
                                HStack {
                                    
                                    Text(place.calling)
                                        .font(.system(size: 20))
                                        .bold()
                                        .padding()
                                    Button{
                                        
                                    }label: {
                                        Image(systemName: "heart.circle")
                                            .padding(-10)
                                    }
                                    Spacer()
                                }
                                
                                //                                .padding(.bottom)
                                HStack {
                                    Text(place.streetName + " (" + place.postalCode + ")")
                                        .bold()
                                        .padding(15)
                                    Spacer()
                                }
                                HStack {
                                    Spacer(minLength: 18)
                                    Text(place.address)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(-20)
                                        .padding(.horizontal)
                                }
                                Spacer(minLength: 40)
                                Text(place.details)
                                    .multilineTextAlignment(.center)
                                    .padding(20)
                                Button{
                                    if let url = URL(string: place.findWeb) {
                                        UIApplication.shared.open(url)
                                    }
                                }label:{
                                    Text("Find out more")
                                }
                                
                            }
                        } label: {
                            // The label of the NavigationLink
                            Text(place.calling)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
            .searchable(text: $searchText)
        }
    }
    //Smart search
    var searchResults: [placeInformation] {
        if searchText.isEmpty {
            return placeStory
        } else {
            return placeStory.filter { $0.calling.localizedCaseInsensitiveContains(searchText) }
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

