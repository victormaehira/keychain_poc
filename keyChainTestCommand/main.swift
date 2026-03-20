//
//  main.swift
//  keyChainTestCommand
//
//  Created by Victor Yuji Maehira on 20/03/26.
//

import Foundation
import Security

print("Vou chamar listIdentities!")
listIdentities()

func listIdentities() {
    
    let query: [String: Any] = [
        kSecClass as String: kSecClassIdentity,
        kSecReturnRef as String: true,
        kSecMatchLimit as String: kSecMatchLimitAll
    ]
    
    var result: CFTypeRef?
    
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    guard status == errSecSuccess else {
        print("Erro ao buscar identidades: \(status)")
        return
    }
    
    guard let identities = result as? [SecIdentity] else {
        print("Nenhuma identidade encontrada")
        return
    }
    
    for identity in identities {
        
        var certificate: SecCertificate?
        SecIdentityCopyCertificate(identity, &certificate)
        
        if let cert = certificate {
            let summary = SecCertificateCopySubjectSummary(cert) as String? ?? "Sem nome"
            
            print("Certificado: \(summary)")
            
            if let data = SecCertificateCopyData(cert) as Data? {
                print("Tamanho do certificado: \(data.count) bytes")
            }
                
        }
        
        var privateKey: SecKey?
        let keyStatus = SecIdentityCopyPrivateKey(identity, &privateKey)
        
        if keyStatus == errSecSuccess {
            print("Tem chave privada associada ✅")
        } else {
            print("Sem chave privada ❌")
        }
        
        print("---------------------------")
    }
}
