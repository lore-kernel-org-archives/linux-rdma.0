From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net v2] net/mlx5: fix uaccess beyond "count" in debugfs
 read/write handlers
Date: Wed, 11 Jul 2018 19:10:38 +0000
Message-ID: <063e455ca5fc8af9f888eb9afd03f24f4320db25.camel@mellanox.com>
References: <20180706201809.105152-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180706201809.105152-1-jannh@google.com>
Content-Language: en-US
Content-ID: <72918A0A00DFAC49B498D4A7054AE0BC@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "jannh@google.com" <jannh@google.com>, "davem@davemloft.net" <davem@davemloft.net>, "leon@kernel.org" <leon@kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTA3LTA2IGF0IDIyOjE4ICswMjAwLCBKYW5uIEhvcm4gd3JvdGU6DQo+IElu
IGdlbmVyYWwsIGFjY2Vzc2luZyB1c2Vyc3BhY2UgbWVtb3J5IGJleW9uZCB0aGUgbGVuZ3RoIG9m
IHRoZQ0KPiBzdXBwbGllZA0KPiBidWZmZXIgaW4gVkZTIHJlYWQvd3JpdGUgaGFuZGxlcnMgY2Fu
IGxlYWQgdG8gYm90aCBrZXJuZWwgbWVtb3J5DQo+IGNvcnJ1cHRpb24NCj4gKHZpYSBrZXJuZWxf
cmVhZCgpL2tlcm5lbF93cml0ZSgpLCB3aGljaCBjYW4gZS5nLiBiZSB0cmlnZ2VyZWQgdmlhDQo+
IHN5c19zcGxpY2UoKSkgYW5kIHByaXZpbGVnZSBlc2NhbGF0aW9uIGluc2lkZSB1c2Vyc3BhY2Uu
DQo+IA0KPiBJbiB0aGlzIGNhc2UsIHRoZSBhZmZlY3RlZCBmaWxlcyBhcmUgaW4gZGVidWdmcyAo
YW5kIHNob3VsZCB0aGVyZWZvcmUNCj4gb25seQ0KPiBiZSBhY2Nlc3NpYmxlIHRvIHJvb3QpIGFu
ZCBjaGVjayB0aGF0ICpwb3MgaXMgemVybyAod2hpY2ggcHJldmVudHMNCj4gdGhlDQo+IHN5c19z
cGxpY2UoKSB0cmljaykuIFRoZXJlZm9yZSwgdGhpcyBpcyBub3QgYSBzZWN1cml0eSBmaXgsIGJ1
dA0KPiByYXRoZXIgYQ0KPiBzbWFsbCBjbGVhbnVwLg0KPiANCj4gRm9yIHRoZSByZWFkIGhhbmRs
ZXJzLCBmaXggaXQgYnkgdXNpbmcgc2ltcGxlX3JlYWRfZnJvbV9idWZmZXIoKQ0KPiBpbnN0ZWFk
IG9mDQo+IGN1c3RvbSBsb2dpYy4NCj4gRm9yIHRoZSB3cml0ZSBoYW5kbGVyLCBhZGQgYSBjaGVj
ay4NCj4gDQo+IGNoYW5nZWQgaW4gdjI6DQo+ICAtIGFsc28gZml4IGRiZ193cml0ZSgpDQo+IA0K
PiBGaXhlczogZTEyNmJhOTdkYmE5ICgibWx4NTogQWRkIGRyaXZlciBmb3IgTWVsbGFub3ggQ29u
bmVjdC1JQg0KPiBhZGFwdGVycyIpDQo+IFNpZ25lZC1vZmYtYnk6IEphbm4gSG9ybiA8amFubmhA
Z29vZ2xlLmNvbT4NCj4gDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0LCBUaGFua3MhIQ0K
