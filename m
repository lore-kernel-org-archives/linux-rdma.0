From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/12] {net,IB}/mlx5: Move Page fault EQ and ODP
 logic to RDMA
Date: Mon, 19 Nov 2018 18:43:24 +0000
Message-ID: <247d4d885b0c04c8c28e54156a7c43b96fe0de10.camel@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
         <20181116215901.5874-12-saeedm@mellanox.com>
         <20181117201347.GA14593@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181117201347.GA14593@mellanox.com>
Content-Language: en-US
Content-ID: <4B946B165B6CE54883085D8C4F005513@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gU2F0LCAyMDE4LTExLTE3IGF0IDIwOjEzICswMDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDE2LCAyMDE4IGF0IDAxOjU5OjAwUE0gLTA4MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IFVzZSB0aGUgbmV3IGdlbmVyaWMgRVEgQVBJIHRvIG1vdmUgYWxsIE9E
UCBSRE1BIGRhdGEgc3RydWN0dXJlcyBhbmQNCj4gPiBsb2dpYw0KPiA+IGZvcm0gbWx4NSBjb3Jl
IGRyaXZlciBpbnRvIG1seDVfaWIgZHJpdmVyLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMZW9u
IFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IFRhcmlx
IFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCg0KWy4uLl0NCg0KPiA+ICANCj4gPiArc3Ry
dWN0IG1seDVfaWJfcGZfZXEgew0KPiA+ICsJc3RydWN0IG1seDVfaWJfZGV2ICAgICAgKmRldjsN
Cj4gPiArCXN0cnVjdCBtbHg1X2VxICAgICAgICAgICpjb3JlOw0KPiA+ICsJc3RydWN0IHdvcmtf
c3RydWN0ICAgICAgIHdvcms7DQo+ID4gKwlzcGlubG9ja190ICAgICAgICAgICAgICAgbG9jazsg
LyogUGFnZWZhdWx0cyBzcGlubG9jayAqLw0KPiA+ICsJc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3Qg
ICp3cTsNCj4gPiArCW1lbXBvb2xfdCAgICAgICAgICAgICAgICAqcG9vbDsNCj4gPiArfTsNCj4g
DQo+IEkga25vdyB0aGlzIGlzIGJlaW5nIGNvcGllZCwgYnV0IGNhbiB3ZSBwbGVhc2Ugbm90IGRv
IHRoaXMgdmVydGljYWwNCj4gYWxpZ25tZW50IG1hZG5lc3MgaW4gUkRNQT8gSXQgaXMgc3VjaCBh
IG5pZ2h0bWFyZSB0byBtYWludGFpbiB0aGlzLi4NCj4gDQoNCkFjayB3aWxsIGZpeCBhbmQgc3Vi
bWl0IHYyLg0KDQo+ID4gKy8qIG1lbXBvb2xfcmVmaWxsKCkgd2FzIHByb3Bvc2VkIGJ1dCB1bmZv
cnR1bmF0ZWx5IHdhc24ndCBhY2NlcHRlZA0KPiA+ICsgKiBodHRwOi8vbGttbC5pdS5lZHUvaHlw
ZXJtYWlsL2xpbnV4L2tlcm5lbC8xNTEyLjEvMDUwNzMuaHRtbA0KPiA+ICsgKiBDaGlwIHdvcmth
cm91bmQuDQo+IA0KPiAnY2hlYXAgd29ya2Fyb3VuZCcNCj4gDQoNCldpbGwgZml4DQoNCj4gSmFz
b24NCg==
