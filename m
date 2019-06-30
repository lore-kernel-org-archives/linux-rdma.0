From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH v2 15/27] net: use zeroing allocator rather than allocator
 followed by memset zero
Date: Sun, 30 Jun 2019 12:19:49 +0000
Message-ID: <741d9946-ff30-1df1-1de0-592621531387@mellanox.com>
References: <20190628024824.15581-1-huangfq.daxian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190628024824.15581-1-huangfq.daxian@gmail.com>
Content-Language: en-US
Content-ID: <A80E9E5F6E5D8B4DA0E5ECDAD3C4D3C8@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCk9uIDYvMjgvMjAxOSA1OjQ4IEFNLCBGdXFpYW4gSHVhbmcgd3JvdGU6DQo+IFJlcGxhY2Ug
YWxsb2NhdG9yIGZvbGxvd2VkIGJ5IG1lbXNldCB3aXRoIDAgd2l0aCB6ZXJvaW5nIGFsbG9jYXRv
ci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEZ1cWlhbiBIdWFuZyA8aHVhbmdmcS5kYXhpYW5AZ21h
aWwuY29tPg0KPiAtLS0NCg0KLi4NCg0KDQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDQvZW5fcnguYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg0L2VuX3J4LmMNCj4gQEAgLTEwNjIsNyArMTA2Miw3IEBAIHN0YXRpYyBpbnQgbWx4NF9l
bl9jb25maWdfcnNzX3FwKHN0cnVjdCBtbHg0X2VuX3ByaXYgKnByaXYsIGludCBxcG4sDQo+ICAg
CXN0cnVjdCBtbHg0X3FwX2NvbnRleHQgKmNvbnRleHQ7DQo+ICAgCWludCBlcnIgPSAwOw0KPiAg
IA0KPiAtCWNvbnRleHQgPSBrbWFsbG9jKHNpemVvZigqY29udGV4dCksIEdGUF9LRVJORUwpOw0K
PiArCWNvbnRleHQgPSBremFsbG9jKHNpemVvZigqY29udGV4dCksIEdGUF9LRVJORUwpOw0KPiAg
IAlpZiAoIWNvbnRleHQpDQo+ICAgCQlyZXR1cm4gLUVOT01FTTsNCj4gICANCj4gQEAgLTEwNzMs
NyArMTA3Myw2IEBAIHN0YXRpYyBpbnQgbWx4NF9lbl9jb25maWdfcnNzX3FwKHN0cnVjdCBtbHg0
X2VuX3ByaXYgKnByaXYsIGludCBxcG4sDQo+ICAgCX0NCj4gICAJcXAtPmV2ZW50ID0gbWx4NF9l
bl9zcXBfZXZlbnQ7DQo+ICAgDQo+IC0JbWVtc2V0KGNvbnRleHQsIDAsIHNpemVvZigqY29udGV4
dCkpOw0KPiAgIAltbHg0X2VuX2ZpbGxfcXBfY29udGV4dChwcml2LCByaW5nLT5hY3R1YWxfc2l6
ZSwgcmluZy0+c3RyaWRlLCAwLCAwLA0KPiAgIAkJCQlxcG4sIHJpbmctPmNxbiwgLTEsIGNvbnRl
eHQpOw0KPiAgIAljb250ZXh0LT5kYl9yZWNfYWRkciA9IGNwdV90b19iZTY0KHJpbmctPndxcmVz
LmRiLmRtYSk7DQo+IA0KDQoNCkZvciB0aGUgbWx4NCBwYXJ0Og0KUmV2aWV3ZWQtYnk6IFRhcmlx
IFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCg0KVGFyaXENCg==
