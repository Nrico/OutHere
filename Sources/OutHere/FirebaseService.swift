import Foundation
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
#endif

final class FirebaseService: ObservableObject {
    static let shared = FirebaseService()

    #if canImport(FirebaseCore)
    private let db = Firestore.firestore()
    #endif
    @Published private(set) var userID: String = ""

    private init() {
        configure()
    }

    private func configure() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        if let uid = Auth.auth().currentUser?.uid {
            userID = uid
        } else {
            Auth.auth().signInAnonymously { [weak self] result, _ in
                if let uid = result?.user.uid {
                    DispatchQueue.main.async {
                        self?.userID = uid
                    }
                }
            }
        }
        #endif
    }

    // MARK: Spots
    func observeSpots(update: @escaping ([SpotLocation]) -> Void) {
        #if canImport(FirebaseCore)
        db.collection("spots").addSnapshotListener { snapshot, _ in
            guard let docs = snapshot?.documents else { return }
            let spots: [SpotLocation] = docs.compactMap { doc in
                SpotLocation(from: doc)
            }
            DispatchQueue.main.async {
                update(spots)
            }
        }
        #endif
    }

    // MARK: Presence
    func checkIn(userID: String, spotID: String, mode: UserPresence) {
        #if canImport(FirebaseCore)
        let doc = db.collection("presence").document()
        doc.setData([
            "userID": userID,
            "spotID": spotID,
            "presenceMode": mode.rawValue,
            "timestamp": Timestamp(date: Date())
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 600) {
            doc.delete()
        }
        #endif
    }

    func observePresence(for spotID: String, update: @escaping (Int) -> Void) {
        #if canImport(FirebaseCore)
        db.collection("presence")
            .whereField("spotID", isEqualTo: spotID)
            .whereField("timestamp", isGreaterThan: Timestamp(date: Date().addingTimeInterval(-600)))
            .addSnapshotListener { snapshot, _ in
                let count = snapshot?.documents.count ?? 0
                DispatchQueue.main.async {
                    update(count)
                }
            }
        #endif
    }
}
