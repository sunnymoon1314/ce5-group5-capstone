# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/google" {
  version     = "4.84.0"
  constraints = ">= 2.12.0, >= 3.45.0, >= 3.83.0, >= 4.29.0, ~> 4.40, < 5.0.0"
  hashes = [
    "h1:PhC05RRIJi2iPLf9ny2JsYxVlhdC4LvXsuPfg4U/Pbg=",
    "h1:yF3EvGbN+7hGQKhPbZijmFk24UDTw9yldkQ1isUM+B4=",
    "zh:0b3e945fa76876c312bdddca7b18c93b734998febb616b2ebb84a0a299ae97c2",
    "zh:1d47d00730fab764bddb6d548fed7e124739b0bcebb9f3b3c6aa247de55fb804",
    "zh:29bff92b4375a35a7729248b3bc5db8991ca1b9ba640fc25b13700e12f99c195",
    "zh:382353516e7d408a81f1a09a36f9015429be73ca3665367119aad88713209d9a",
    "zh:78afa20e25a690d076eeaafd7879993ef9763a8a1b6762e2cbe42330464cc1fa",
    "zh:8f6422e94de865669b33a2d9fb95a3e392e841988e890f7379a206e9d47e3415",
    "zh:be5c7b52c893b971c860146aec643f7007f34430106f101eab686ed81eccbd26",
    "zh:bfc37b641bf3378183eb3b8735554c3949a5cfaa8f76403d7eff38de1474b6d9",
    "zh:c834f88dc8eb21af992871ed13a221015ae3b051aeca7386662071026f1546b4",
    "zh:f3296c8c0d57dc28e23cf91717484264531655ac478d994584ebc73f70679471",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
    "zh:f8efe114ff4891776f48f7d2620b8d6963d3ddac6e42ce25bc761343da964c24",
  ]
}

provider "registry.terraform.io/hashicorp/google-beta" {
  version     = "4.84.0"
  constraints = ">= 3.45.0, < 5.0.0"
  hashes = [
    "h1:5xn3rZN6ofjHpiu8roZ0D/ZM1aWwpGX40igxHUzWWKE=",
    "h1:yltuUeGBlRWABk9GLny0mhlEW1+pIW1VEf1o4FYpJWA=",
    "zh:0c17bd21a0d98a5063b5bbdad0feac559913061264953d96b3b82289b9938d83",
    "zh:138dd45494953f6ce0f837ab29ca61ff91e2001e7cf49356021a962030ccf217",
    "zh:1846d617cd39cc7da60280686e1ba63239a4a200f30386dd66a633ea5789e307",
    "zh:38d715a828573923d0129fa258b64360f77fbb437c605e26dba95e6b8cf79b53",
    "zh:4a041086cabbcaaf9982051297ab864003c7e042b4a8d47c2bfaa47fc83886cb",
    "zh:78bfc252ad0e56f2fd10abc25d1e79acb7bd95383017ea4ee309e8c5b15a338b",
    "zh:7f193c7b32851e3c704ecf713f93d3ab78031e82d47ac0b4ccf3ecd6be3dda2d",
    "zh:8c0f381aee7d3029ec7f0bc1e80ae545a9a522ec764648a9a4e024cfaac3d6f5",
    "zh:cae23495634d780f92f241fde2718ef627ed6485225241dd90ef375eb710c0ea",
    "zh:d7ccfb67d072870a6c54e76f5ac5fc9a817bd1392dfac81a964bae4cb36ca096",
    "zh:e0adbd1e0bf48224c3d352423df5f1bcd62f4e95fe26c981720fbf81f863f57e",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/kubernetes" {
  version     = "2.30.0"
  constraints = "~> 2.10"
  hashes = [
    "h1:/vj6txgGBrH2NhCiAucn7+F3TznBUZevg+w64TPdVsQ=",
    "h1:KFBOyOGlS+BGrDfbuVdBhTIRefDo+vJEO/IooUR6T4g=",
    "zh:06531333a72fe6d2829f37a328e08a3fc4ed66226344a003b62418a834ac6c69",
    "zh:34480263939ef5007ce65c9f4945df5cab363f91e5260ae552bcd9f2ffeed444",
    "zh:59e71f9177da570c33507c44828288264c082d512138c5755800f2cd706c62bc",
    "zh:6e979b0c07326f9c8d1999096a920322d22261ca61d346b3a9775283d00a2fa5",
    "zh:73e3f228de0077b5c0a84ec5b1ada507fbb3456cba35a6b5758723f77715b7af",
    "zh:79e0de985159c056f001cc47a654620d51f5d55f554bcbcde1fe7d52f667db40",
    "zh:8accb9100f609377db42e3ced42cc9d5c36065a06644dfb21d3893bb8d4797fd",
    "zh:9f99aa0bf5caa4223a7dbf5d22d71c16083e782c4eea4b0130abfd6e6f1cec18",
    "zh:bcb2ad76ad05ec23f8da62231a2360d1f70bbcd28abd06b8458a9e2f17da7873",
    "zh:bce317d7790c2d3c4e724726dc78070db28daf7d861faa646fc891fe28842a29",
    "zh:ed0a8e7fa8a1c419a19840b421d18200c3a63cf16ccbcbc400cb375d5397f615",
    "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
  ]
}

provider "registry.terraform.io/hashicorp/random" {
  version = "3.6.2"
  hashes = [
    "h1:5lstwe/L8AZS/CP0lil2nPvmbbjAu8kCaU/ogSGNbxk=",
    "h1:Gd3WitYIzSYo/Suo+PMxpZpIGpRPrwl0JU0+DhxycFM=",
    "zh:0ef01a4f81147b32c1bea3429974d4d104bbc4be2ba3cfa667031a8183ef88ec",
    "zh:1bcd2d8161e89e39886119965ef0f37fcce2da9c1aca34263dd3002ba05fcb53",
    "zh:37c75d15e9514556a5f4ed02e1548aaa95c0ecd6ff9af1119ac905144c70c114",
    "zh:4210550a767226976bc7e57d988b9ce48f4411fa8a60cd74a6b246baf7589dad",
    "zh:562007382520cd4baa7320f35e1370ffe84e46ed4e2071fdc7e4b1a9b1f8ae9b",
    "zh:5efb9da90f665e43f22c2e13e0ce48e86cae2d960aaf1abf721b497f32025916",
    "zh:6f71257a6b1218d02a573fc9bff0657410404fb2ef23bc66ae8cd968f98d5ff6",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:9647e18f221380a85f2f0ab387c68fdafd58af6193a932417299cdcae4710150",
    "zh:bb6297ce412c3c2fa9fec726114e5e0508dd2638cad6a0cb433194930c97a544",
    "zh:f83e925ed73ff8a5ef6e3608ad9225baa5376446349572c2449c0c0b3cf184b7",
    "zh:fbef0781cb64de76b1df1ca11078aecba7800d82fd4a956302734999cfd9a4af",
  ]
}
