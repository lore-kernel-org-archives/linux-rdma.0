From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/4] net/mlx5: Move flow counters data
 structures from flow steering header
Date: Wed, 5 Dec 2018 22:26:26 +0000
Message-ID: <29c008d0437571d4ce358ffdf5d3530ca8fce23c.camel@mellanox.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
         <20181205020303.16318-5-saeedm@mellanox.com>
         <CAM_iQpX4W4svScQC+49gbx84om4gRLa9L5oKP01-H23ZuQ-PNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpX4W4svScQC+49gbx84om4gRLa9L5oKP01-H23ZuQ-PNw@mail.gmail.com>
Content-Language: en-US
Content-ID: <4634514CDA29984FB59756C7E5D41680@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTEyLTA0IGF0IDIxOjA0IC0wODAwLCBDb25nIFdhbmcgd3JvdGU6DQo+IE9u
IFR1ZSwgRGVjIDQsIDIwMTggYXQgNjowNSBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gQWZ0ZXIgdGhlIGZvbGxvd2luZyBmbG93IGNvdW50ZXJz
IEFQSSByZWZhY3RvcmluZzoNCj4gPiAoIm5ldC9tbHg1OiBVc2UgZmxvdyBjb3VudGVyIElEcyBh
bmQgbm90IHRoZSB3cmFwcGluZyBjYWNoZQ0KPiA+IG9iamVjdCIpDQo+ID4gZmxvdyBjb3VudGVy
cyBwcml2YXRlIGRhdGEgc3RydWN0dXJlcyBtbHg1X2ZjX2NhY2hlIGFuZCBtbHg1X2ZjIGFyZQ0K
PiA+IHJlZHVuZGFudGx5IGV4cG9zZWQgaW4gZnNfY29yZS5oLCB0aGV5IGhhdmUgbm90aGluZyB0
byBkbyB3aXRoIGZsb3cNCj4gPiBzdGVlcmluZyBjb3JlIGFuZCB0aGV5IGFyZSBwcml2YXRlIHRv
IGZzX2NvdW50ZXIuYywgdGhpcyBwYXRjaA0KPiA+IG1vdmVzIHRoZW0NCj4gPiB0byB3aGVyZSB0
aGV5IGJlbG9uZyBhbmQgcmVkdWNlcyB0aGVpciBleHBvc3VyZSBpbiB0aGUgZHJpdmVyLg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29t
Pg0KPiA+IC0tLQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19j
b3JlLmggfCAyMyAtLS0tLS0tLS0tLS0tDQo+ID4gLS0tLS0tDQo+ID4gIC4uLi9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZnNfY291bnRlcnMuYyB8IDIzDQo+ID4gKysrKysrKysrKysrKysr
KysrKw0KPiANCj4gVGhlICNpbmNsdWRlIDxsaW51eC9sbGlzdC5oPiBjYW4gYmUgbW92ZWQgdG9n
ZXRoZXIgdG9vLg0KDQpzdXJlIHdpbGwgZG8gdGhhdCBpbiBWMg0KdGhhbmtzIENvbmchDQo=
