//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    let apiKey = "AIzaSyBR3QC4KWiC1WXUis2sRqYRgPvFSoGFrCM"
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
        return true
    }
}

@main
struct MainEntryPoint {
    static func main() {
        let isInUiTestMode = ProcessInfo.processInfo.arguments.contains("UI_TEST_MODE")
        
        if isUnitTestMode() {
            EventoriasUnitTestApp.main()
        } else if isInUiTestMode {
            EventoriasUiTestApp.main()
        } else {
            EventoriasApp.main()
        }
    }
    
    private static func isUnitTestMode() -> Bool {
        return NSClassFromString("XCTestCase") != nil
    }
}

struct EventoriasUnitTestApp: App {
    var body: some Scene {
        WindowGroup {}
    }
}

struct EventoriasUiTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewModel: EventoriasAppViewModel
    
    init() {
        let isLogged = ProcessInfo.processInfo.environment["UI_TEST_LOGGED_IN"] == "true"
        let authenticationService = MockAuthenticationService()
        authenticationService.shouldSucceedLogin = true
        authenticationService.shouldSucceedRegistration = true
        let imageUploaderMock = MockImageUploader()
        imageUploaderMock.shouldFail = false
        let eventServiceMock = MockEventService()
        eventServiceMock.shouldSucceed = true
        eventServiceMock.eventsWithUserDetails = [
            EventModel(id: "fakeId", title: "Soirée Art", address: "Rue de Rivoli, 75001 Paris, France", description: "Step into an evening of artistic exploration in the heart of Paris. This event features a curated selection of contemporary artworks by both emerging and established artists from across Europe. Attendees will enjoy live performances, interactive installations, and guided tours of the exhibitions. This is a must-visit for art enthusiasts and collectors alike, offering a rare opportunity to connect with the creators behind the masterpieces", imageUrl: "https://firebasestorage.googleapis.com/v0/b/eventorias-2ad80.firebasestorage.app/o/events%2Fimages%2F559449-visuel-paris-rue-de-rivoli-velo.jpg?alt=media&token=93082b22-9506-4384-bf42-fcc512128273", dateTime: Date.now, category: "Art", profilePictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/eventorias-2ad80.firebasestorage.app/o/users%2FprofilePictures%2FC2C88AF0-A49E-4D8E-860C-DF0CDE92EF63.jpg91EBDC3F-18F5-4E5A-B525-F0117B39D151?alt=media&token=f7e45401-e3ba-47f7-b1f0-5e7c49b59e39")
        ]
        let addEventServiceMock = MockAddEventService()
        addEventServiceMock.shouldSucceedAddEvent = true
        let userServiceMock = UserServiceMock()
        userServiceMock.shouldSucceed = true
        userServiceMock.user = UserResponseModel(email: "test@test.com", firstName: "John", lastName: "Doe", profilePicture: "fakeUrl")
        
        _viewModel = StateObject(wrappedValue: EventoriasAppViewModel(
            isLogged: isLogged,
            authenticationService: authenticationService,
            imageUploader: imageUploaderMock,
            eventService: eventServiceMock,
            addEventService: addEventServiceMock,
            userService: userServiceMock
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(appViewModel: viewModel)
        }
    }
}

struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewModel: EventoriasAppViewModel
    
    init() {
        FirebaseApp.configure()
        
        let authenticationService = AuthenticationService()
        let imageUploader = ImageUploader()
        let eventService = EventService()
        let addEventService = AddEventService()
        let userService = UserService()
        
        _viewModel = StateObject(wrappedValue: EventoriasAppViewModel(
            isLogged: false,
            authenticationService: authenticationService,
            imageUploader: imageUploader,
            eventService: eventService,
            addEventService: addEventService,
            userService: userService
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(appViewModel: viewModel)
        }
    }
}

struct MainCoordinatorView: View {
    @ObservedObject var appViewModel: EventoriasAppViewModel
    
    init(appViewModel: EventoriasAppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        if appViewModel.isLogged {
            MainTabView(
                eventListViewModel: appViewModel.eventListViewModel,
                userProfileViewModel: appViewModel.userProfileViewModel
            )
        } else {
            SignInView(viewModel: appViewModel.authenticationViewModel)
        }
    }
}

struct MainTabView: View {
    private let eventListViewModel: EventListViewModel
    private let userProfileViewModel: UserProfileViewModel
    
    init(eventListViewModel: EventListViewModel, userProfileViewModel: UserProfileViewModel) {
        self.eventListViewModel = eventListViewModel
        self.userProfileViewModel = userProfileViewModel
    }
    
    var body: some View {
        TabView {
            EventListView(viewModel: eventListViewModel)
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            UserProfileView(viewModel: userProfileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .accessibilityIdentifier("userProfileTab")
        }
        .accentColor(.customRed)
    }
}
