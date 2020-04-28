 //
 //  ApiManager.swift

 
 import UIKit
 import Alamofire
 import SwiftyJSON
 
 class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager.init()
    
    func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        Alamofire.request(strURL, method: .post, parameters: params, encoding: URLEncoding.default , headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestGetURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        Alamofire.request(strURL, method: .get, parameters: params, encoding: URLEncoding.default , headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestMultiPartURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]? , imagesArray : [UIImage], imageName: [String],  success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if imagesArray.count != 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM_dd_yy_HH:mm:ss.SS"
                for i in 0..<imagesArray.count{
                    let img =  imagesArray[i].compressImageToData() ?? imagesArray[i].jpegData(compressionQuality: 0.3)
                    if img != nil{
                        let date = formatter.string(from: Date())
                        multipartFormData.append(img!, withName: "\(imageName[i])", fileName: "swift_file\(date).jpg", mimeType: "image/jpg")
                    }
                }
            }
            for (key, value ) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold:UInt64.init(),
           to: strURL,
           method: .post,
           headers:headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _ ,_ ):
                upload.uploadProgress(closure: { (progress) in
                    UILabel().text = "\((progress.fractionCompleted * 100)) %"
                    print (progress.fractionCompleted * 100)
                })
                upload.responseData { response in
                    let responseData = String(data: response.result.value!, encoding: .utf8)
                    print(responseData!)
                    let resJson = JSON(response.result.value ?? Dictionary<String, Any>())
                    success(resJson)
                }
//                upload.responseJSON { response in
//                    print(response.result.value)
//                    let resJson = JSON(response.result.value ?? Dictionary<String, Any>())
//                    success(resJson)
//                }
            case .failure(let encodingError):
                failure(encodingError.localizedDescription)
            }
        })
    }
    
    func requestMultiPartURLVideo(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]? , VideoURL: URL?, videoName: String,  success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM_dd_yy_HH:mm:ss.SS"
            
            let date = formatter.string(from: Date())
            do{
                
                let data = try Data(contentsOf: VideoURL!)
                
                multipartFormData.append(data, withName: videoName, fileName: "swift_file\(date).mp4", mimeType: "video/mp4")
            }catch {
                
            }
            for (key, value ) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold:UInt64.init(),
           to: strURL,
           method: .post,
           headers:headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _ ,_ ):
                upload.uploadProgress(closure: { (progress) in
                    print (progress.fractionCompleted * 100)
                })
                upload.responseJSON { response in
                    let resJson = JSON(response.result.value ?? Dictionary<String, Any>())
                    success(resJson)
                }
            case .failure(let encodingError):
                failure(encodingError.localizedDescription)
            }
        })
    }
    
    func requestTwoMultiPartURL(_ strURL : String, params : [String : String]?, headers : [String : String]? , imagesArray : [UIImage], imageName: [String],videoImage: UIImage, videoImageName: String, success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        
        Alamofire.SessionManager.default.upload(multipartFormData: { (multipartFormData) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM_dd_yy_HH:mm:ss.SS"
            if imagesArray.count != 0 {
                for i in 0..<imagesArray.count{
                    let img =  imagesArray[i].compressImageToData() ?? imagesArray[i].jpegData(compressionQuality: 0.3)
                    if img != nil{
                        let date = formatter.string(from: Date())
                        multipartFormData.append(img!, withName: "\(imageName[i])", fileName: "swift_file\(date).jpg", mimeType: "image/jpg")
                    }
                }
            }
            let img =  videoImage.compressImageToData() ?? videoImage.jpegData(compressionQuality: 0.3)
            if img != nil{
                let date = formatter.string(from: Date())
                multipartFormData.append(img!, withName: "\(videoImageName)", fileName: "swift_file\(date).jpg", mimeType: "image/jpg")
            }
            for (key, value ) in params! {
                multipartFormData.append(value.data(using: .utf8, allowLossyConversion: false)!, withName: key)
            }
        }, to: strURL,
           method: .post,
           headers:headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _ ,_ ):
                upload.uploadProgress(closure: { (progress) in
                    UILabel().text = "\((progress.fractionCompleted * 100)) %"
                    print (progress.fractionCompleted * 100)
                })
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                    let resJson = JSON(response.result.value ?? Dictionary<String, Any>())
                    success(resJson)
                }
            case .failure(let encodingError):
                failure(encodingError.localizedDescription)
            }
        }
    }
    
 }
 
 
 //MARK:- Api Keys
 //=======================
 struct ApiCode {
    
    static var success: Int                     { return 201 } // Success
    static var invalidCredentials: Int          { return 204 } // Invalid Password
    static var otpExpired: Int                  { return 401 } // OTP Expired
    static var userAlreadyExist: Int            { return 403 } // User Already Exist
    static var userNotExist: Int                { return 404 } // User Not Exist
    static var ssnAlreadyExist: Int             { return 409 } // SSN Already Exist
    static var fieldValidationFailed: Int       { return 422 } // Field Validation Failed
    static var serverError: Int                 { return 500 } // Internal Server Error
    static var otpNotUpdate: Int                { return 503 } // Could Not Update
    
 }
 
 extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality:compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    func compressImageToData() -> Data? {
        // Reducing file size to a 10th
        var actualHeight : CGFloat = self.size.height
        var actualWidth : CGFloat = self.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        
        UIGraphicsBeginImageContext(rect.size);
        
        
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        let imageData = (img ?? UIImage.init(named: "imgDefault")!).jpegData(compressionQuality: compressionQuality)
        
        
        UIGraphicsEndImageContext();
        
        return imageData
    }
    
 }
