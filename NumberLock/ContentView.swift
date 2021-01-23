//
//  ContentView.swift
//  NumberLock
//
//  Created by 张亚飞 on 2021/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            Home()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct  Home : View {
    
    @State var unLocked = false
    
    var body: some View {
        
        ZStack {
            
            if unLocked {
                
                Text("APP Unlocked")
            }
            else {
                
                LockScreen(unLocked: $unLocked)
            }
        }
        .preferredColorScheme(unLocked ? .light : .dark)
    }
}

struct LockScreen : View {
    
    @State var password = ""
    //Appstorage => UserDefaults
    @AppStorage("lock_Password") var key = "4628"
    @Binding var unLocked : Bool
    @State var wrongPassword = false
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Menu(content: {
                    
                    Label(
                        
                        title: { Text("Help") },
                        icon: { Image(systemName: "info.circle.fill") })
                        .onTapGesture {
                            
                        }
                    
                    Label(
                        
                        title: { Text("Reset Password") },
                        icon: { Image(systemName: "key.fill") })
                        .onTapGesture {
                            
                        }
                    
                }) {
                    
                    Image(systemName: "filemenu.and.selection")
                        .renderingMode(.template)
                        .frame(width: 19, height: 19)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading)
            
            Image("headerImg")
                .resizable()
                .frame(width: 95, height: 95)
                .clipShape(Circle())
                .padding(.top, 20)
                
            Text("Enter Pin to Unlock")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top, 20)
            
            HStack(spacing: 20) {
                
                ForEach(0...3, id:\.self) { index in
                    PasswordView(index: index, password: $password)
                }
     
                
            }
            .padding(.top, 20)
            
            Spacer()
            
            Text(wrongPassword ? "Incorrect Pin" : "")
                .foregroundColor(.red)
                .fontWeight(.heavy)
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing : 15, content: {
                
                ForEach(1...9, id:\.self) { index in
                    
                    PasswordButton(value: "\(index)", password: $password, key: $key, unLocked: $unLocked, wrongPassword: $wrongPassword)
                }
                
                PasswordButton(value: "delete.fill", password: $password, key: $key, unLocked: $unLocked, wrongPassword: $wrongPassword)
                
                PasswordButton(value: "0", password: $password, key: $key, unLocked: $unLocked, wrongPassword: $wrongPassword)
            })
            .padding(.bottom)
            
//            Spacer()
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}



struct PasswordView : View {
    
    var index : Int
    @Binding var password : String
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 30, height: 30)
            
            if password.count > index {
                
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: 30, height: 30)
                Text(password[index])

            }
            
        }
    }
}


struct PasswordButton : View {
    
    var value : String
    @Binding var password : String
    @Binding var key : String
    @Binding var unLocked : Bool
    @Binding var wrongPassword : Bool
    
    var body: some View {
        
        Button(action: setPaddword, label: {
            
            VStack {
                
                if value.count > 1 {
                    
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                } else
                {
                    
                    Text(value)
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding()
            
        })
    }
    
    func setPaddword() {
        
        withAnimation {
            
            if value.count > 1 {
                
                if password.count != 0 {
                    
                    password.removeLast()
                }
                wrongPassword = false
            }
            else {
                
                if password.count != 4 {
                    
                    password.append(value)
                    
                    if password.count == 4 {
                        
                        //Delay Animation
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            
                            withAnimation{
                                
                                if password == key {
                                    
                                    unLocked.toggle()
                                }
                                else {
                                    
                                    wrongPassword = true
                                    password.removeAll()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}





extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
