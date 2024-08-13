
// Services.swift
// RGB
//
// Created by usamaghalzai on 15/11/2021.
// Copyright © 2021 usamaghalzai. All rights reserved.
//
import Foundation
import UIKit
enum SenderType: String {
  case dealer = "Dealer"
  case support = "AAV Support"
  var backgroundColor : UIColor {
    switch self {
    case .dealer:
      return UIColor.init(hexString: "F2994A").withAlphaComponent(0.25)
    case .support:
      return UIColor.init(hexString: "2F80ED").withAlphaComponent(0.25)
    }
  }
  var textColor : UIColor {
    switch self {
    case .dealer:
      return UIColor.init(hexString: "F2994A")
    case .support:
      return UIColor.init(hexString: "2F80ED")
    }
  }
}
enum NetworkEnvironment {
  case live
  case staging
  case local
}
struct AppConstants {
  static let gcmMessageIDKey = ""
  static let PRODUCT_ID: Int = 2
  struct API{
      static let environment: NetworkEnvironment = .live
    static var baseURL: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://apid.bazaarghar.com/v1/")!
        case .staging:
          return URL(string: "https://apix-stage.bazaarghar.com/v1/")!
      case.local:
        return URL(string: "http://192.168.1.44:3000/v1/")!
      }
    }
    static var typeSenseUrl: URL {
       switch AppConstants.API.environment{
        case .live:
         return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=EeWttEyOdPY8OjKA0E6ayaSWHuyaS8yd")!
        case .staging:
        //return URL(string: "http://192.168.1.41:3003/chat/v1/message")!
        return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn")!
       case.local:
        return URL(string: "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn")!
       }
      }
    static var baseURLSearchProduct: URL {
      switch AppConstants.API.environment{
      case .live:
        return URL(string: "https://apid.bazaarghar.com/v2/")!
      case .staging:
        return URL(string: "https://apix-stage.bazaarghar.com/v2/")!
      case.local:
        return URL(string: "http://192.168.1.44:3000/v2/")!
      }
    }
    static var baseURLVideoStreaming: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://apid.bazaarghar.com/streaming/v2/")!
        case .staging:
          return URL(string: "https://apix-stage.bazaarghar.com/streaming/v1/")!
      case.local:
        return URL(string: "http://192.168.1.44:3002/streaming/v1/")!
      }
    }
      static var baseURLVideoStreamingV1: URL {
        switch AppConstants.API.environment{
          case .live:
            return URL(string: "https://apid.bazaarghar.com/streaming/v1/")!
          case .staging:
            return URL(string: "https://apix-stage.bazaarghar.com/streaming/v1/")!
        case.local:
          return URL(string: "http://192.168.1.44:3002/streaming/v1/")!
        }
      }
    static var baseURLChat: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/message")!
        case .staging:
        //return URL(string: "http://192.168.1.41:3003/chat/v1/message")!
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/message")!
      case.local:
        return URL(string: "http://192.168.1.44:3003/chat/v1/message")!
      }
    }
    static var chinesBellUrl: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/message")!
        case .staging:
        //return URL(string: "http://192.168.1.41:3003/chat/v1/message")!
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/notification")!
      case.local:
        return URL(string: "http://192.168.1.44:3003/chat/v1/notification")!
      }
    }
    static var baseURLChatNotification: URL {
      switch AppConstants.API.environment{
        case .live:
          return URL(string: "https://chat-apid.bazaarghar.com/chat/v1/")!
        case .staging:
        //return URL(string: "http://192.168.1.41:3003/chat/v1/message")!
          return URL(string: "https://chat-api-stage.bazaarghar.com/chat/v1/")!
      case.local:
        return URL(string: "http://192.168.1.44:3003/chat/v1/")!
      }
    }
    static let signalRHUB = "https://aquaticavchat.azurewebsites.net/signalr"
    //static let signalRHUB = "https://aquaticavchatdev.azurewebsites.net/signalr"
  //  static let signalRHUB = "https://5fbe-2407-d000-a-ba51-44b1-db3d-583b-1a6c.ngrok.io/signalr"
    //static let ngRokSignalR = "https://9eb1-206-84-151-58.ngrok.io/signalr"
    //static let ngRokSignalR = "https://5fbe-2407-d000-a-ba51-44b1-db3d-583b-1a6c.ngrok.io/signalr"
    static let signalRConnectionURL = URL(string: "https://aquaticavchat.azurewebsites.net/api/")!
    //static let signalRConnectionURL = URL(string: "https://aquaticavchatdev.azurewebsites.net/api/")!
  //  static let signalRConnectionURL = URL(string: "https://5fbe-2407-d000-a-ba51-44b1-db3d-583b-1a6c.ngrok.io/api/")!
    static let ngrokConnectionURL = URL(string: "https://5fbe-2407-d000-a-ba51-44b1-db3d-583b-1a6c.ngrok.io/api/")!
    //static let ngrokConnectionURL = URL(string: "https://9eb1-206-84-151-58.ngrok.io/api/")!
    static var baseURLString = AppConstants.API.baseURL.absoluteString
    static let imageBasePath:String = "https://aavazurestorage.blob.core.windows.net/ofishassetsstaging/"
  }
  struct UserDefaultKeys{
    static let user = "user"
  }
  struct Keys{
    static let googleApiKey = "AIzaSyDmGVRqxuXsUGlDBosd3I5ptRVySLSi6UQ"
  }
}
