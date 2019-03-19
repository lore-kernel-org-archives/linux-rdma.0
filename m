From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH v4] net: mlx5: Add a missing check on idr_find, free buf
Date: Tue, 19 Mar 2019 22:37:46 +0000
Message-ID: <03f5d2ac3d4e312cffcbc7e61cc10815c28dfeb7.camel@mellanox.com>
References: <20190319214244.20212-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190319214244.20212-1-pakki001@umn.edu>
Content-Language: en-US
Content-ID: <6311568127E32E48B038A028A924A08B@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "pakki001@umn.edu" <pakki001@umn.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>, "kjlu@umn.edu" <kjlu@umn.edu>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>, "davem@davemloft.net" <davem@davemloft.net>, "leon@kernel.org" <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDE2OjQyIC0wNTAwLCBBZGl0eWEgUGFra2kgd3JvdGU6DQo+
IGlkcl9maW5kKCkgY2FuIHJldHVybiBhIE5VTEwgdmFsdWUgdG8gJ2Zsb3cnIHdoaWNoIGlzIHVz
ZWQgd2l0aG91dCBhDQo+IGNoZWNrLiBUaGUgcGF0Y2ggYWRkcyBhIGNoZWNrIHRvIGF2b2lkIHBv
dGVudGlhbCBOVUxMIHBvaW50ZXINCj4gZGVyZWZlcmVuY2UuDQo+IA0KPiBJbiBjYXNlIG9mIG1s
eDVfZnBnYV9zYnVfY29ubl9zZW5kbXNnKCkgZmFpbHVyZSwgZnJlZSBidWYgYWxsb2NhdGVkDQo+
IHVzaW5nIGt6YWxsb2MuDQo+IA0KPiBGaXhlczogYWI0MTJlMWRkN2RiICgibmV0L21seDU6IEFj
Y2VsLCBhZGQgVExTIHJ4IG9mZmxvYWQgcm91dGluZXMiKQ0KPiAtLS0NCj4gdjM6IFJlb3JkZXIg
YnVmIGFsbG9jYXRpb25zIGFuZCBmbG93IGNoZWNrLg0KPiB2MjogZmFpbHVyZSB0byByZXR1cm4g
aW4gY2FzZSBvZiBmbG93IGZhaWx1cmUuDQo+IHYxOiBGYWlsZWQgdG8gZnJlZSBidWYgaW4gY2Fz
ZSBvZiBmbG93IGZhaWx1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBZGl0eWEgUGFra2kgPHBh
a2tpMDAxQHVtbi5lZHU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2ZwZ2EvdGxzLmMgfCAxNCArKysrKysrKysrKy0NCj4gLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCg0KQXBwbGllZCB0
byBuZXQtbWx4NSwgd2lsbCBiZSBzZW50IHVwc3RyZWFtIHNob3J0bHksDQoNCllvdSBtZXNzZWQg
dXAgdGhlIFNpZ25lZC1vZmYgdGFnLCBpdCBhbHNvIHNob3VsZCBoYXZlIGJlZW4gcGFydCBvZiB0
aGUNCmNvbW1pdCBtZXNzYWdlLCBidXQgZG9uJ3Qgd29ycnksIGkgZml4ZWQgaXQgdXAgYW5kIGFk
ZGVkIFl1dmFsJ3MNClJldmlld2VkLWJ5Lg0KDQpUaGFua3MgQWRlaXR5YSBmb3IgaGFuZGxpbmcg
YWxsIG9mIHRoZSBjb21tZW50cy4NClNhZWVkLg0KDQo=
