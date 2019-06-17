From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Date: Mon, 17 Jun 2019 21:30:34 +0000
Message-ID: <69c6a9cfe132a4437bc7d481fb9aeddbe57f7114.camel@mellanox.com>
References: <20190617110855.2085326-1-arnd@arndb.de>
         <20190617.140230.537297372523260104.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617.140230.537297372523260104.davem@davemloft.net>
Content-Language: en-US
Content-ID: <23411EEE6753F64894B885E3F75CECE2@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>, Paul Blakey <paulb@mellanox.com>, Mark Bloch <markb@mellanox.com>, Maor Gottlieb <maorg@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eli Britstein <elibr@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDE0OjAyIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+DQo+IERhdGU6IE1vbiwgMTcgSnVu
IDIwMTkgMTM6MDg6MjIgKzAyMDANCj4gDQo+ID4gUHV0dGluZyBhbiBlbXB0eSAnbWx4NV9mbG93
X3NwZWMnIHN0cnVjdHVyZSBvbiB0aGUgc3RhY2sgaXMgYSBiaXQNCj4gPiB3YXN0ZWZ1bCBhbmQg
Y2F1c2VzIGEgd2FybmluZyBvbiAzMi1iaXQgYXJjaGl0ZWN0dXJlcyB3aGVuIGJ1aWxkaW5nDQo+
ID4gd2l0aCBjbGFuZyAtZnNhbml0aXplLWNvdmVyYWdlOg0KPiA+IA0KPiA+IGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX3Rlcm10YmwuYzoN
Cj4gPiBJbiBmdW5jdGlvbiAnbWx4NV9lc3dpdGNoX3Rlcm10YmxfY3JlYXRlJzoNCj4gPiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkc190ZXJt
dGJsLmM6DQo+ID4gOTA6MTogZXJyb3I6IHRoZSBmcmFtZSBzaXplIG9mIDEwMzIgYnl0ZXMgaXMg
bGFyZ2VyIHRoYW4gMTAyNCBieXRlcw0KPiA+IFstV2Vycm9yPWZyYW1lLWxhcmdlci10aGFuPV0N
Cj4gPiANCj4gPiBTaW5jZSB0aGUgc3RydWN0dXJlIGlzIG5ldmVyIHdyaXR0ZW4gdG8sIHdlIGNh
biBzdGF0aWNhbGx5IGFsbG9jYXRlDQo+ID4gaXQgdG8gYXZvaWQgdGhlIHN0YWNrIHVzYWdlLiBU
byBiZSBvbiB0aGUgc2FmZSBzaWRlLCBtYXJrIGFsbA0KPiA+IHN1YnNlcXVlbnQgZnVuY3Rpb24g
YXJndW1lbnRzIHRoYXQgd2UgcGFzcyBpdCBpbnRvIGFzICdjb25zdCcNCj4gPiBhcyB3ZWxsLg0K
PiA+IA0KPiA+IEZpeGVzOiAxMGNhYWJkYWFkNWEgKCJuZXQvbWx4NWU6IFVzZSB0ZXJtaW5hdGlv
biB0YWJsZSBmb3IgVkxBTg0KPiA+IHB1c2ggYWN0aW9ucyIpDQo+ID4gU2lnbmVkLW9mZi1ieTog
QXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gDQo+IFNhZWVkLCBvbmNlIEFybmQgZml4
ZXMgdGhlIHJldmVyc2UgY2hyaXN0bWFzIHRyZWUgaXNzdWUsIEkgYXNzdW1lIHlvdQ0KPiB3aWxs
IHRha2UNCj4gdGhpcyBpbiB2aWEgeW91ciB0cmVlPw0KDQpZZXMsIHRoaXMgaXMgYSBjb3JlIGNo
YW5nZSB0aGF0IG1pZ2h0IGNvbmZsaWN0IHdpdGggc29tZSBvbmdvaW5nIHN0dWZmLg0KDQpUaGFu
ayB5b3UgRGF2ZSAhDQpTYWVlZC4NCg==
