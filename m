From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] [v2] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Date: Tue, 18 Jun 2019 20:05:56 +0000
Message-ID: <6eae69d099b2818f03e661e489f87b3adb94bf17.camel@mellanox.com>
References: <20190618111621.3030135-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618111621.3030135-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <CFCA9F575402AD44A774A299FC2B1D44@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "arnd@arndb.de" <arnd@arndb.de>, "leon@kernel.org" <leon@kernel.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>, Paul Blakey <paulb@mellanox.com>, Mark Bloch <markb@mellanox.com>, Maor Gottlieb <maorg@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, Eli Britstein <elibr@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDEzOjE1ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBQdXR0aW5nIGFuIGVtcHR5ICdtbHg1X2Zsb3dfc3BlYycgc3RydWN0dXJlIG9uIHRoZSBzdGFj
ayBpcyBhIGJpdA0KPiB3YXN0ZWZ1bCBhbmQgY2F1c2VzIGEgd2FybmluZyBvbiAzMi1iaXQgYXJj
aGl0ZWN0dXJlcyB3aGVuIGJ1aWxkaW5nDQo+IHdpdGggY2xhbmcgLWZzYW5pdGl6ZS1jb3ZlcmFn
ZToNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
X29mZmxvYWRzX3Rlcm10YmwuYzoNCj4gSW4gZnVuY3Rpb24gJ21seDVfZXN3aXRjaF90ZXJtdGJs
X2NyZWF0ZSc6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoX29mZmxvYWRzX3Rlcm10YmwuYzo5MA0KPiA6MTogZXJyb3I6IHRoZSBmcmFtZSBzaXplIG9m
IDEwMzIgYnl0ZXMgaXMgbGFyZ2VyIHRoYW4gMTAyNCBieXRlcyBbLQ0KPiBXZXJyb3I9ZnJhbWUt
bGFyZ2VyLXRoYW49XQ0KPiANCj4gU2luY2UgdGhlIHN0cnVjdHVyZSBpcyBuZXZlciB3cml0dGVu
IHRvLCB3ZSBjYW4gc3RhdGljYWxseSBhbGxvY2F0ZQ0KPiBpdCB0byBhdm9pZCB0aGUgc3RhY2sg
dXNhZ2UuIFRvIGJlIG9uIHRoZSBzYWZlIHNpZGUsIG1hcmsgYWxsDQo+IHN1YnNlcXVlbnQgZnVu
Y3Rpb24gYXJndW1lbnRzIHRoYXQgd2UgcGFzcyBpdCBpbnRvIGFzICdjb25zdCcNCj4gYXMgd2Vs
bC4NCj4gDQo+IEZpeGVzOiAxMGNhYWJkYWFkNWEgKCJuZXQvbWx4NWU6IFVzZSB0ZXJtaW5hdGlv
biB0YWJsZSBmb3IgVkxBTiBwdXNoDQo+IGFjdGlvbnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5k
IEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiBBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQo+IEFja2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5v
eC5jb20+DQoNCkFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NSBhbmQgd2lsbCBiZSBzdWJtaXR0ZWQg
dG8gbmV0LW5leHQgc29vbi4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
