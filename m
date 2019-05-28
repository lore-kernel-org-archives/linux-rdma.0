From: Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH] mlx5: avoid 64-bit division
Date: Tue, 28 May 2019 14:44:09 +0000
Message-ID: <849F6C89-EB21-4EAA-A1C0-1E4941B4812E@mellanox.com>
References: <20190520111902.7104DE0184@unicorn.suse.cz>
 <20190520112835.GF4573@mtr-leonro.mtl.com>
 <20190528140145.GO4633@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528140145.GO4633@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <8D2E75104A3334448B4F36227A58C61E@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

DQogICBPbiBNb24sIE1heSAyMCwgMjAxOSBhdCAwMjoyODozNVBNICswMzAwLCBMZW9uIFJvbWFu
b3Zza3kgd3JvdGU6DQogICAgPiA+IE9uIE1vbiwgTWF5IDIwLCAyMDE5IGF0IDAxOjE5OjAyUE0g
KzAyMDAsIE1pY2hhbCBLdWJlY2VrIHdyb3RlOg0KICAgID4gPiA+IENvbW1pdCAyNWMxMzMyNGQw
M2QgKCJJQi9tbHg1OiBBZGQgc3RlZXJpbmcgU1cgSUNNIGRldmljZSBtZW1vcnkgdHlwZSIpDQog
ICAgPiA+ID4gYnJlYWtzIGkzODYgYnVpbGQgYnkgaW50cm9kdWNpbmcgdGhyZWUgNjQtYml0IGRp
dmlzaW9ucy4gQXMgdGhlIGRpdmlzb3INCiAgICA+ID4gPiBpcyBNTFg1X1NXX0lDTV9CTE9DS19T
SVpFKCkgd2hpY2ggaXMgYWx3YXlzIGEgcG93ZXIgb2YgMiwgd2UgY2FuIHJlcGxhY2UNCiAgICA+
ID4gPiB0aGUgZGl2aXNpb24gd2l0aCBiaXQgb3BlcmF0aW9ucy4NCiAgICA+ID4NCiAgICA+ID4g
SW50ZXJlc3RpbmcsIHdlIHRyaWVkIHRvIHNvbHZlIGl0IGRpZmZlcmVudGx5Lg0KICAgID4gPiBJ
IGFkZGVkIGl0IHRvIG91ciByZWdyZXNzaW9uIHRvIGJlIG9uIHRoZSBzYW1lIHNpZGUuDQogICAg
DQogICAgPiBUaGlzIHBhdGNoIHdvcmtzIGZvciB1cy4NCiAgICANCiAgIFllcywgdGhpcyB2YWx1
ZSBpcyBndWFyYW50ZWVkIHRvIGJlIGEgcG93ZXIgb2YgMi4gIFdlIHNhZmVseSB1c2Ugcm91bmRf
dXAoKSBpbnN0ZWFkIGFzIHN1Z2dlc3RlZCBpbiB0aGUgcGF0Y2guDQoNCg==
