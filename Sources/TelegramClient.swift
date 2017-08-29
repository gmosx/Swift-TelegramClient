import Foundation
import KituraRequest
import KituraNet

public typealias JSONCompletion = (_ response: [String: Any]) -> Void

/// Telegram Bot API client.
/// https://core.telegram.org/bots/api
/// https://core.telegram.org/bots/webhooks
/// https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates
public class TelegramClient {
    let botToken: String
    let telegramApiURL: String
    var lastUpdateId: Int

    public init(botToken: String) {
        self.botToken = botToken
        self.telegramApiURL = "https://api.telegram.org/bot\(botToken)"
        self.lastUpdateId = 0
    }

    public func request(method: String, parameters: [String: Any] = [:], completion: @escaping JSONCompletion) {
        KituraRequest.request(.post, "\(telegramApiURL)/\(method)", parameters: parameters).response {
            request, response, data, error in
            if let data = data,
               let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] {
                   completion(json)
            }
        }
    }

    public func getMe(completion: @escaping JSONCompletion) {
        request(
            method: "getMe",
            completion: completion
        )
    }

    public func getUpdates(offset: Int? = nil, completion: @escaping JSONCompletion) {
        request(
            method: "getUpdates",
            parameters: offset != nil ? ["offset": offset!] : [:],
            completion: completion
        )
    }

    public func nextUpdates(completion: @escaping JSONCompletion) {
        getUpdates(offset: lastUpdateId) { response in
            if let result = response["result"] as? [[String: Any]] {
                for update in result {
                    if let updateId = update["update_id"] as? Int {
                        self.lastUpdateId = updateId + 1
                    }
                }
                completion(["result": result])
            }
        }
    }

    public func sendMessage(chatId: Int, text: String, completion: @escaping JSONCompletion) {
        request(
            method: "sendMessage",
            parameters: [
                "chat_id": chatId,
                "text": text
            ],
            completion: completion
        )
    }

    public func setWebhook(url: URL, certificate: Data? = nil, maxConnections: Int? = nil, allowedUpdates: [String]? = nil, completion: @escaping JSONCompletion) {
        request(
            method: "setWebhook",
            parameters: [
                "url": url.absoluteString
            ],
            completion: completion
        )
    }

    public func deleteWebhook(completion: @escaping JSONCompletion) {
        request(
            method: "deleteWebhook",
            completion: completion
        )
    }
}
