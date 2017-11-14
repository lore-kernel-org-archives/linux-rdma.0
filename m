From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 27/31] IB/cm: Fix honor address handle attribute
 init error
Date: Tue, 14 Nov 2017 22:13:17 +0000
Message-ID: <VI1PR0502MB3008514AED6DA3E970381088D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-28-leon@kernel.org>
 <CAJ3xEMjPsD7+YnN80A7Z3WjxEey20=TYKpxrRK_mRhKVMEnA8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjPsD7+YnN80A7Z3WjxEey20=TYKpxrRK_mRhKVMEnA8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT3IgR2VybGl0eiBbbWFp
bHRvOmdlcmxpdHoub3JAZ21haWwuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxNCwg
MjAxNyAzOjE0IFBNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NCj4g
Q2M6IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT47IGxpbnV4LXJkbWFAdmdlci5r
ZXJuZWwub3JnOyBIZWZ0eSwNCj4gU2VhbiA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+OyBMZW9uIFJv
bWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggcmRt
YS1uZXh0IDI3LzMxXSBJQi9jbTogRml4IGhvbm9yIGFkZHJlc3MgaGFuZGxlIGF0dHJpYnV0ZQ0K
PiBpbml0IGVycm9yDQo+IA0KPiBPbiBUdWUsIE5vdiAxNCwgMjAxNyBhdCAyOjUyIFBNLCBMZW9u
IFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4gd3JvdGU6DQo+ID4gRnJvbTogUGFyYXYgUGFu
ZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQo+ID4NCj4gPiBjbV9pbml0X2F2X2J5X3BhdGggZGVw
ZW5kcyBvbiBpYl9pbml0X2FoX2Zyb21fcGF0aCB0byBpbml0aWFsaXplIGFoDQo+ID4gYXR0cmli
dXRlIGFuZCBpYl9pbml0X2FoX2Zyb21fcGF0aCgpIGNhbiBmYWlsLCBzdWNoIGVycm9yIHNob3Vs
ZCBub3QNCj4gPiBiZSBpZ25vcmVkLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBob25vcnMgYWggYXR0
cmlidXRlIGluaXQgZXJyb3IuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQg
PHBhcmF2QG1lbGxhbm94LmNvbT4NCj4gDQo+IGFueSByZWFzb24gbm90IHRvIHBvaW50IG91dCB0
aGUgY29tbWl0IHRoYXQgaW50cm9kdWNlZCB0aGUgYnVnPw0KTm8gcGFydGljdWxhciByZWFzb24u
IEkgYW0gbm90IHN1cmUgZmV3IHllYXJzIGJhY2sgaXQgd2FzIGJ1ZyBvciBub3QuIEluIGN1cnJl
bnQgY29kZSBpdCBhcHBlYXIgc28uDQpTbyBJIGNvbnRpbnVlZCB3aXRob3V0IEZpeGVzIGNvbW1p
dCBsaW5lLg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
