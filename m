From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH net-next 2/4] net/hyperv: use skb_vlan_tag_*() helpers
Date: Tue, 20 Nov 2018 20:37:17 +0000
Message-ID: <DM5PR2101MB1013614A5E560CE8B8956EABCAD90@DM5PR2101MB1013.namprd21.prod.outlook.com>
References: <cover.1542716156.git.mirq-linux@rere.qmqm.pl>
 <61f737ec45c9905d5c86fbe8492eaa604bf6549f.1542716156.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <61f737ec45c9905d5c86fbe8492eaa604bf6549f.1542716156.git.mirq-linux@rere.qmqm.pl>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Ajit Khaparde <ajit.khaparde@broadcom.com>, Leon Romanovsky <leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Sathya Perla <sathya.perla@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWljaGHFgiBNaXJvc8WC
YXcgPG1pcnEtbGludXhAcmVyZS5xbXFtLnBsPg0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAy
MCwgMjAxOCA3OjIxIEFNDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBLWSBT
cmluaXZhc2FuIDxreXNAbWljcm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcNCj4gPGhhaXlhbmd6
QG1pY3Jvc29mdC5jb20+OyBTdGVwaGVuIEhlbW1pbmdlcg0KPiA8c3RoZW1taW5AbWljcm9zb2Z0
LmNvbT47IGRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmc7IEFqaXQgS2hhcGFyZGUNCj4gPGFq
aXQua2hhcGFyZGVAYnJvYWRjb20uY29tPjsgTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5v
cmc+Ow0KPiBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgU2FlZWQgTWFoYW1lZWQgPHNhZWVk
bUBtZWxsYW5veC5jb20+Ow0KPiBTYXRoeWEgUGVybGEgPHNhdGh5YS5wZXJsYUBicm9hZGNvbS5j
b20+OyBTb21uYXRoIEtvdHVyDQo+IDxzb21uYXRoLmtvdHVyQGJyb2FkY29tLmNvbT47IFNyaWhh
cnNoYSBCYXNhdmFwYXRuYQ0KPiA8c3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJyb2FkY29tLmNvbT4N
Cj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IDIvNF0gbmV0L2h5cGVydjogdXNlIHNrYl92bGFu
X3RhZ18qKCkgaGVscGVycw0KPiANCj4gUmVwbGFjZSBvcGVuLWNvZGVkIGJpdGZpZWxkIG1hbmlw
dWxhdGlvbiB3aXRoIHNrYl92bGFuX3RhZ18qKCkgaGVscGVycy4NCj4gVGhpcyBhbHNvIGVuYWJs
ZXMgY29ycmVjdGx5IHBhc3Npbmcgb2YgVkxBTi5DRkkgYml0Lg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogTWljaGHFgiBNaXJvc8WCYXcgPG1pcnEtbGludXhAcmVyZS5xbXFtLnBsPg0KPiAtLS0NCg0K
UmV2aWV3ZWQtYnk6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQpUaGFu
a3MuDQoNCg==
