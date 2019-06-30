From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH 87/87] ethernet: mlx4: remove memset after
 dma_alloc_coherent
Date: Sun, 30 Jun 2019 12:15:33 +0000
Message-ID: <4645429b-1429-34bb-e181-74c461ace04a@mellanox.com>
References: <20190627174227.4726-1-huangfq.daxian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627174227.4726-1-huangfq.daxian@gmail.com>
Content-Language: en-US
Content-ID: <A51E0748EDA4C240AF843394D503CD31@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCk9uIDYvMjcvMjAxOSA4OjQyIFBNLCBGdXFpYW4gSHVhbmcgd3JvdGU6DQo+IEluIGNvbW1p
dCBhZjdkZGQ4YTYyN2MNCj4gKCJNZXJnZSB0YWcgJ2RtYS1tYXBwaW5nLTQuMjEnIG9mIGdpdDov
L2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2hjaC9kbWEtbWFwcGluZyIpLA0KPiBkbWFfYWxsb2Nf
Y29oZXJlbnQgaGFzIGFscmVhZHkgemVyb2VkIHRoZSBtZW1vcnkuDQo+IFNvIG1lbXNldCBpcyBu
b3QgbmVlZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRnVxaWFuIEh1YW5nIDxodWFuZ2ZxLmRh
eGlhbkBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDQvZXEuYyB8IDIgLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VxLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VxLmMNCj4gaW5kZXggYTViZTI3
NzcyYjhlLi5jNzkwYTVmY2VhNzMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDQvZXEuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg0L2VxLmMNCj4gQEAgLTEwMTMsOCArMTAxMyw2IEBAIHN0YXRpYyBpbnQgbWx4NF9jcmVh
dGVfZXEoc3RydWN0IG1seDRfZGV2ICpkZXYsIGludCBuZW50LA0KPiAgIA0KPiAgIAkJZG1hX2xp
c3RbaV0gPSB0Ow0KPiAgIAkJZXEtPnBhZ2VfbGlzdFtpXS5tYXAgPSB0Ow0KPiAtDQo+IC0JCW1l
bXNldChlcS0+cGFnZV9saXN0W2ldLmJ1ZiwgMCwgUEFHRV9TSVpFKTsNCj4gICAJfQ0KPiAgIA0K
PiAgIAllcS0+ZXFuID0gbWx4NF9iaXRtYXBfYWxsb2MoJnByaXYtPmVxX3RhYmxlLmJpdG1hcCk7
DQo+IA0KDQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0K
DQpUaGFua3MuDQo=
