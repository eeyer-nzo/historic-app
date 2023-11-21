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
    @State private var spacerMnLngth: CGFloat = 300
    @State private var showFav = false
    @State private var zoomInOut = 0.001
    
    
    var body: some View {
        //Everything on screen starts here{
        
        ZStack {
            
            MapView(zoomInOut: $zoomInOut)
                .edgesIgnoringSafeArea(.top)
            
            VStack{
                 
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
                            DragGesture()
                                .onChanged { value in
                                    // Update sheet position based on drag gesture
                                    withAnimation {
                                        sheetPosition = max(min(value.translation.height, 0), -UIScreen.main .bounds.height)
                                    }
                                }
                            
                                .onEnded { value in
                                    // Determine whether to show or hide the sheet based on drag distance
                                    let threshold: CGFloat = -100
                                    
                                    //BTW you can edit the code but ONLY the one below if u understand whats going on wtv is above DO NOT TOUCH is the sheet movement code.
                                    
                                    //What happens when the sheet goes up
                                    
                                    withAnimation(.bouncy){ //only Xcode 15.0 has snappy animation, so yall will get an error. How to fix: get rid of "(.snappy)" yes the brackets too. Theres another one down at 3 paragraphs.
                                        
                                        chkShtTbPos = true
                                        if chkShtTbPos == true{
                                            spacerMnLngth = -300
                                        }
                                    }
                                    if value.translation.height < threshold {
                                        withAnimation {
                                            // This controls how high the sheet goes up
                                            sheetPosition =  -UIScreen.main.bounds.height
                                            + 560
                                            showSheet = false
                                            
                                        }
                                    } else { // What happens when sheet goes down
                                        
                                        withAnimation(.bouncy){
                                            //only Xcode 15.0 has snappy animation, so yall will get an error. How to fix: get rid of "(.snappy)" yes the brackets too
                                            
                                            chkShtTbPos = false
                                            if chkShtTbPos == false{
                                                spacerMnLngth = 300
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
                    // The spacer 🎵 push and pull like a magnet do 🎵 the Tab Bar
                    Spacer(minLength: spacerMnLngth)
                }
            }
            //Vstack ends here
            .background(Color(.systemBackground))
            .offset(y: sheetPosition + 350)
            
        }
    }
    // and ends roughly somewhere here
}

//Edits everthing displayed on the sheet{
struct CustomSheetView: View {
    let names = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat", "I wonder"]
    @State private var searchText = ""
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                     
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
                                    print("favourite!")
                                } label: {
                                    Label(" ", systemImage: "heart.circle")
                                    
                                }
                                
                            }
                            HStack {
                                Text("2 Fusionopolis Way, Singapore 138634")
                                    .font(.system(size: 17))
                                    .bold()
                                Image(systemName: "location.circle.fill")
                            }
                            Text("blablablablabla something about history idk extend this thing alot cookie monster chicken nugget french fry onion ring upsize coca cola zero sugar two plus two equals to four")
                            Spacer()
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
            .navigationTitle("Locations")
            
            .searchable(text: $searchText)
            
            
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
