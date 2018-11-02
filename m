From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 22:07:02 +0000
Message-ID: <4ebfc3aeb5335a1f671602f9a906f948c39a30da.camel@mellanox.com>
References: <20181102153316.1492515-1-arnd@arndb.de>
         <9f214f12ec89020ceb14c1aec25b3a0d968507aa.camel@mellanox.com>
         <2727f37b-1742-5532-317e-3be8a984266b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2727f37b-1742-5532-317e-3be8a984266b@gmail.com>
Content-Language: en-US
Content-ID: <EE2A7BA9AE0993429F5915ED0B1D2D6F@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>, "leon@kernel.org" <leon@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Eran Ben Elisha <eranbe@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>, Kamal Heib <kamalh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTExLTAyIGF0IDE0OjM5IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IA0KPiBPbiAxMS8wMi8yMDE4IDAyOjA1IFBNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gIA0K
PiA+IHRlbXAgd2lsbCBiZSBtZW0gY29waWVkIHRvIHByaXYtPnN0YXRzLnN3IGF0IHRoZSBlbmQs
DQo+ID4gbWVtY3B5KCZwcml2LT5zdGF0cy5zdywgJnMsIHNpemVvZihzKSk7IA0KPiA+IA0KPiA+
IG9uZSBvdGhlciB3YXkgdG8gc29sdmUgdGhpcyBhcyBzdWdnZXN0ZWQgYnkgQW5kcmV3LCBpcyB0
byBnZXQgcmlkDQo+ID4gb2YNCj4gPiB0aGUgdGVtcCB2YXIgYW5kIG1ha2UgaXQgcG9pbnQgZGly
ZWN0bHkgdG8gcHJpdi0+c3RhdHMuc3cgDQo+ID4gDQo+IA0KPiBXaGF0IGFib3V0IGNvbmN1cnJl
bmN5ID8NCj4gDQo+IFRoaXMgdGVtcCB2YXJpYWJsZSBpcyB0aGVyZSB0byBtYWtlIHN1cmUgY29u
Y3VycmVudCByZWFkZXJzIG9mIHN0YXRzDQo+IG1pZ2h0DQo+IG5vdCBzZWUgbWFuZ2xlIGRhdGEg
KGJlY2F1c2UgYW5vdGhlciAncmVhZGVyJyBqdXN0IGRpZCBhIG1lbXNldCgpIGFuZA0KPiBpcyBk
b2luZyB0aGUgZm9sZGluZykNCj4gDQo+IA0KPiBtbHg1ZV9nZXRfc3RhdHMoKSBjYW4gZGVmaW5p
dGVseSBiZSBydW4gYXQgdGhlIHNhbWUgdGltZSBieSBtdWx0aXBsZQ0KPiB0aHJlYWRzLg0KPiAN
Cg0KaG1tLCB5b3UgYXJlIHJpZ2h0LCBpIHdhcyB0aGlua2luZyB0aGF0IG1seDVlX2dldF9TdGF0
cyB3aWxsIHRyaWdnZXIgYQ0Kd29yayB0byB1cGRhdGUgc3RhdHMgYW5kIGdyYWIgdGhlIHN0YXRl
X2xvY2ssIGJ1dCBmb3Igc3cgc3RhdHMgdGhpcyBpcw0Kbm90IHRoZSBjYXNlIGl0IGlzIGRvbmUg
aW4gcGxhY2UuDQoNCkJUVyBtZW1jcHkgaXRzZWxmIGlzIG5vdCB0aHJlYWQgc2FmZS4NCg==
