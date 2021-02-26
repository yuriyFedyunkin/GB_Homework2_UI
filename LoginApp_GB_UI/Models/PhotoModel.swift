//
//  PhotoModel.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 14.02.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object, Decodable {
    @objc dynamic var likes = 0
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case sizes
        case likes
    }
    
    enum SizesKeys: String, CodingKey {
        case url
        case type
    }
    
    enum LikesKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        
        let likesValues = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes = (try likesValues.decode(Int.self, forKey: .count)) + (try likesValues.decode(Int.self, forKey: .userLikes))
        
        
        var sizesValue = try values.nestedUnkeyedContainer(forKey: .sizes)
        
        while !sizesValue.isAtEnd {
            let size = try sizesValue.decode(Sizes.self)
            if size.type == "z" || size.type == "y" || size.type == "x" {
                url = size.url
            }
        }
    }
}

class Sizes: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    
}

struct UserPhotoesList: Decodable {
    let items: [Photo]
}

struct VKPhotoGroupsResponse: Decodable {
    let response: UserPhotoesList
}

/*
 {
     "response": {
         "count": 202,
         "items": [
             {
                 "album_id": -7,
                 "date": 1513824764,
                 "id": 456239455,
                 "owner_id": 21463,
                 "has_tags": false,
                 "post_id": 2347,
                 "sizes": [
                     {
                         "height": 97,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=130x97&quality=96&sign=8de3f1b29543c68b4a50a8bce4b837de&c_uniq_tag=2utKwcERhbw4kbwucTRMIliUsYcbVV7Om0ZRFOcrzOU&type=album",
                         "type": "m",
                         "width": 130
                     },
                     {
                         "height": 97,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=130x97&quality=96&sign=8de3f1b29543c68b4a50a8bce4b837de&c_uniq_tag=2utKwcERhbw4kbwucTRMIliUsYcbVV7Om0ZRFOcrzOU&type=album",
                         "type": "o",
                         "width": 130
                     },
                     {
                         "height": 149,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=200x149&quality=96&sign=7f4f835bdb1662c34a26637482a7628c&c_uniq_tag=FtEXA6J0vj_zSrlbkSQjrGCROZoxoCPp_NIHdBTQ2G0&type=album",
                         "type": "p",
                         "width": 200
                     },
                     {
                         "height": 239,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=320x239&quality=96&sign=7f9e7b143108bbc09db5f2196ebcc5ef&c_uniq_tag=zb--9Kfp7cEUrllSuQyyEWl1w8C2owU_0y5S4fVBTVI&type=album",
                         "type": "q",
                         "width": 320
                     },
                     {
                         "height": 380,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=510x380&quality=96&sign=f06e8f4710bb471940b4d6217d4e51c1&c_uniq_tag=riEeWMDC8rJAYiUn9Ae3Eh7wKwFmUsdW-rhE6Kpe1dE&type=album",
                         "type": "r",
                         "width": 510
                     },
                     {
                         "height": 56,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=75x56&quality=96&sign=5486c229f8129098bfd661542765cfdd&c_uniq_tag=fgzDbSeT7ADHTUb-hi0LvzgYUiNn2LCANtmeEhc5Dc0&type=album",
                         "type": "s",
                         "width": 75
                     },
                     {
                         "height": 450,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=604x450&quality=96&sign=c680a9659e287cd0cd3668aa16efff87&c_uniq_tag=OKjY9672PAbhb5QDKM0kCu7bUbw8N9q4UbcArcVVf_E&type=album",
                         "type": "x",
                         "width": 604
                     },
                     {
                         "height": 601,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=807x601&quality=96&sign=b7fec3cfce9656647cc2f49ae19405df&c_uniq_tag=Cgej_HLpzDftq6r_JEmljCpISENl4Zr4SUhGx9ZVmJQ&type=album",
                         "type": "y",
                         "width": 807
                     },
                     {
                         "height": 720,
                         "url": "https://sun9-32.userapi.com/impf/c840132/v840132123/59ecd/7c78I8LFNKw.jpg?size=966x720&quality=96&proxy=1&sign=87c8e7e4b03f3bef213ab3533e6efa19&c_uniq_tag=aiLVuTUUk31Lba6irqC5_I88rxeb9Pco_QZL8ZS8sGY&type=album",
                         "type": "z",
                         "width": 966
                     }
                 ],
                 "text": "",
                 "likes": {
                     "user_likes": 0,
                     "count": 79
                 },
                 "reposts": {
                     "count": 0
                 }
             },
             {
                 "album_id": -7,
                 "date": 1508769253,
                 "id": 456239419,
                 "owner_id": 21463,
                 "has_tags": false,
                 "post_id": 2339,
                 "sizes": [
                     {
                         "height": 101,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=130x101&quality=96&sign=1862615619250e0bbd9104457bd29ff2&c_uniq_tag=Q1IoIFlG-v9rLpWeTAt_9aFj_DJSOhTCUzRuZ2oNQj0&type=album",
                         "type": "m",
                         "width": 130
                     },
                     {
                         "height": 101,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=130x101&quality=96&sign=1862615619250e0bbd9104457bd29ff2&c_uniq_tag=Q1IoIFlG-v9rLpWeTAt_9aFj_DJSOhTCUzRuZ2oNQj0&type=album",
                         "type": "o",
                         "width": 130
                     },
                     {
                         "height": 156,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=200x156&quality=96&sign=9f769b791483f4bd3bc6fa14af91f30a&c_uniq_tag=ZoJwc_egCZ1ULPygIICV_2wK0OJkyXUFoCI24I1L-Zw&type=album",
                         "type": "p",
                         "width": 200
                     },
                     {
                         "height": 249,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=320x249&quality=96&sign=561688f79a41549cc6a1c119fccfdf89&c_uniq_tag=IvFA7v3Tl1VeSteSRpgALudn7QbwrhWAVG-tmjdcytM&type=album",
                         "type": "q",
                         "width": 320
                     },
                     {
                         "height": 397,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=510x397&quality=96&sign=e27ef61160f985e7babb0c49717b195a&c_uniq_tag=lL892PzRDWpy-cbO3jOo8H-e88mk6jNbnLDH_HzCYG0&type=album",
                         "type": "r",
                         "width": 510
                     },
                     {
                         "height": 58,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=75x58&quality=96&sign=c6887bb581df38535121398024474764&c_uniq_tag=or87BUlvJU5RUgXWg8zt-sPojuyTtOR1VdYy3UhFJOY&type=album",
                         "type": "s",
                         "width": 75
                     },
                     {
                         "height": 470,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=604x470&quality=96&sign=6725324f7b247fd4bedaca3b8c87e77d&c_uniq_tag=oHNdSAMpeFFh01x9mbTmGHZ-imzeV-HDIvNMUmnVSk8&type=album",
                         "type": "x",
                         "width": 604
                     },
                     {
                         "height": 628,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=807x628&quality=96&sign=2401ea7779896ee0a06cce50a50744ac&c_uniq_tag=RrqbRi2dFlBzXeSHwzasSX8jrqNFKwZcFZGmk_KQaKw&type=album",
                         "type": "y",
                         "width": 807
                     },
                     {
                         "height": 841,
                         "url": "https://sun9-17.userapi.com/impf/c841629/v841629872/3c135/8GKjwL73YaM.jpg?size=1080x841&quality=96&proxy=1&sign=27bd3e8be61a5ba700f62f64204b467a&c_uniq_tag=qd0HcYNl7mf7a_t_jBGoEQYszWxbRKNJHNJjPijwfxo&type=album",
                         "type": "z",
                         "width": 1080
                     }
                 ],
                 "text": "",
                 "likes": {
                     "user_likes": 1,
                     "count": 59
                 },
                 "reposts": {
                     "count": 0
                 }
             },
 */
