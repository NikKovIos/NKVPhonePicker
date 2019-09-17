//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

#if os(iOS)
extension String {
    var cutSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var cutPluses: String {
        return self.replacingOccurrences(of: "+", with: "")
    }
}
#endif
