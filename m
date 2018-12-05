From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 3/4] IB/mlx5: Use helper to get CQE opcode
Date: Wed, 5 Dec 2018 22:27:12 +0000
Message-ID: <27bad07b447adecf4668dbad32d9dd31f0580fbe.camel@mellanox.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
         <20181205020303.16318-4-saeedm@mellanox.com>
         <20181205062304.GF15544@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205062304.GF15544@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <CBABE0C722339C41B99FD86E9E685BE7@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTEyLTA1IGF0IDA4OjA5ICswMDAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDA0LCAyMDE4IGF0IDA2OjAzOjAyUE0gLTA4MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IEZyb206IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4N
Cj4gPiANCj4gPiBVc2UgdGhlIG5ldyBoZWxwZXIgdGhhdCBleHRyYWN0cyB0aGUgb3Bjb2RlDQo+
ID4gZnJvbSBhIENRRSAoY29tcGxldGlvbiBxdWV1ZSBlbnRyeSkgc3RydWN0dXJlLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY3EuYyB8IDggKysrKy0tLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4g
PiANCj4gDQo+IEkgcmVjb21tZW5kIHlvdSB0byBzcXVhc2ggdGhpcyBwYXRjaCBpbnRvIHRoZSBw
cmV2aW91cyBvbmUuDQo+IA0KPiBUaGFua3MsDQo+IEFja2VkLWJ5OiBMZW9uIFJvbWFub3Zza3kg
PGxlb25yb0BtZWxsYW5veC5jb20+DQoNClRoYW5rcyBMZW9uLCBJIHdvdWxkIGxpa2UgdG8ga2Vl
cCBuZXRkZXYgYW5kIHJkbWEgcGF0Y2hlcyBzZXBhcmF0ZWQgYXMNCm11Y2ggYXMgcG9zc2libGUg
DQo=
