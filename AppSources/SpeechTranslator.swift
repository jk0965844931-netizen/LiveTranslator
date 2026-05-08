import Foundation
import Speech

class SpeechTranslator {
    static let shared = SpeechTranslator()
    
    // ตั้งค่าเป็นภาษาอังกฤษ (เปลี่ยนเป็น th-TH ได้ถ้าจะแปลไทยเป็นข้อความไทย)
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let sharedDefaults = UserDefaults(suiteName: "group.com.yourname.LiveTranslator")

    func startTranslating() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else { return }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }
        
        // บังคับแปลในเครื่อง (Local) ให้เร็วที่สุด
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let result = result {
                let text = result.bestTranscription.formattedString
                // ส่งข้อความไปให้ ContentView แสดงผล
                self?.sharedDefaults?.set(text, forKey: "TranslatedText")
            }
        }
    }
    
    func appendAudioBuffer(_ sampleBuffer: CMSampleBuffer) {
        // โค้ดส่วนนี้จะรับ Buffer จาก Extension มาใส่ใน Speech Request
        // (ในการใช้งานจริงต้องมีการแปลง Format ของเสียงก่อนส่งให้ SpeechRecognizer)
        // recognitionRequest?.append(pcmBuffer)
    }
    
    func stopTranslating() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }
}
