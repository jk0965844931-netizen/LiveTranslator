import SwiftUI

class TranslationObserver: ObservableObject {
    @Published var currentText: String = "กำลังรอรับเสียง..."
    private var timer: Timer?
    // ใช้ App Group เพื่อคุยกับ Extension (ตัวอัดหน้าจอ)
    private let sharedDefaults = UserDefaults(suiteName: "group.com.yourname.LiveTranslator")
    
    init() {
        // ให้แอปเช็คข้อความใหม่ทุกๆ 0.5 วินาที
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            if let text = self?.sharedDefaults?.string(forKey: "TranslatedText") {
                if self?.currentText != text {
                    self?.currentText = text
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var observer = TranslationObserver()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Live Translator")
                .font(.largeTitle)
                .bold()
            
            // กล่องข้อความจำลองสำหรับดึงไปทำ PiP
            ZStack {
                Color.black.opacity(0.85)
                    .frame(height: 150)
                    .cornerRadius(15)
                
                Text(observer.currentText)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("วิธีใช้งาน:")
                    .font(.headline)
                Text("1. ปัดหน้าจอลงมาเปิด Control Center")
                Text("2. กดค้างที่ปุ่ม 'อัดหน้าจอ' (Screen Record)")
                Text("3. เลือกแอป 'BroadcastExt'")
                Text("4. กด Start Broadcast แล้วเปิดเกม/Youtube ได้เลย!")
            }
            .foregroundColor(.gray)
            .padding()
        }
    }
}
