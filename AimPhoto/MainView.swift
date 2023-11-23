//
//  MainView.swift
//

import SwiftUI
import UniformTypeIdentifiers

let coordinates = Coordinates()

struct MainView: View {
    
    @State var scale: CGFloat = 0
    @State var size: CGFloat = 0
    @State var aimOffset: CGSize = CGSizeZero
    @State var lastStoredAimOffset: CGSize = CGSizeZero
    @State var xPosition: CGFloat = 0
    @State var yPosition: CGFloat = 0
    @State private var showSheet = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var showMenu = false
    @State private var isMoving = true
    @State private var showingAlert = false

    private let pasteboard = UIPasteboard.general
    
        
    var body: some View {
        NavigationView {
            GeometryReader {
                let size = $0.size
                ZStack {
                    if let image {
                        GeometryReader { geo in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(GeometryReader { gp -> Color in
                                    let rect = gp.frame(in: .global)
                                    let saveScale = scale
                                    scale = 0
                                    xPosition = rect.minX
                                    yPosition = rect.minY
                                    coordinates.imageX = xPosition
                                    coordinates.imageY = yPosition
                                    print("***********************")
                                    print("x: \(coordinates.x), y:  \(coordinates.y)")
                                    print("x0: \(coordinates.imageX), y0:  \(coordinates.imageY)")
                                    print("XImage: \(coordinates.x - coordinates.imageX), YImage:  \(coordinates.y - coordinates.imageY)")
                                    print("***************")
                                    scale = saveScale
                                    
                                    return Color.clear
                                })
                                .frame(width: size.width, height: size.height)
                                .magnificationEffect(scale, self.size, .green)
                                .ignoresSafeArea()
                                .contentShape(Rectangle())
                        }
                    } else {
                        Button {
                            showSheet = true
                        } label: {
                            Text("Добавить фото")
                                .foregroundColor(.white)
                                .padding()
                                .background(.red)
                                .cornerRadius(15)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showMenu.toggle()
                        } label: {
                            Image(systemName: "pencil.line")
                                .scaleEffect(1.5)
                                .foregroundColor(.red)
                        }
                        .padding(32)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        VStack {
                            HStack (spacing: 14) {
                                Text("Scale")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(width: 35, alignment: .leading)
                                
                                Slider(value: $scale, in: 0...3)
                                
                                Button {
                                    showSheet = true
                                } label: {
                                    Image(systemName: "camera")
                                        .padding()
                                        .foregroundColor(.red)
                                }
                                .actionSheet(isPresented: $showSheet) {
                                    
                                    ActionSheet(title: Text("Select photo"),
                                                message: Text("Choose"), buttons: [
                                                    .default(Text("Photo library")) {
                                                        self.showImagePicker = true
                                                        self.sourceType = .photoLibrary
                                                    },
                                                    .default(Text("Camera")) {
                                                        self.showImagePicker = true
                                                        self.sourceType = .camera
                                                    },
                                                    .cancel()
                                                ]
                                    )
                                }
                            }
                            .tint(.red)
                            
                            HStack (spacing: 14) {
                                Text("Size")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(width: 35, alignment: .leading)

                                Slider(value: $size, in: -50...150)
                                Button {
                                    copyToClipboard()
                                    showingAlert = true
                                } label: {
                                    
                                    Image(systemName: "arrow.right.doc.on.clipboard")
                                        .padding()
                                        .foregroundColor(.red)
                                }
                            }
                            .tint(.red)
                        }
                        .opacity(showMenu ? 1 : 0)
                        .animation(.easeInOut, value: showMenu)
                        .padding()
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background ( content: {
                            Color.black.opacity(0.08)
                                .ignoresSafeArea()
                        })
                }
                .preferredColorScheme(.dark)
                .background(.clear)
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .padding(0)
        .alert(coordinates.description, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            scale = 1.5
        }
    }
    
    func copyToClipboard() {
        pasteboard.string = String("\(coordinates.y - coordinates.imageY)")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
