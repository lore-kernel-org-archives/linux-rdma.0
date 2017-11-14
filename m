From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is
 held
Date: Tue, 14 Nov 2017 22:16:17 +0000
Message-ID: <VI1PR0502MB3008970D8D6034E4A2D952DED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-29-leon@kernel.org>
 <CAJ3xEMixWZvCVDYTK1-2w0pYdy65HExvN2ae7y=hAkk6htrETg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMixWZvCVDYTK1-2w0pYdy65HExvN2ae7y=hAkk6htrETg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT3IgR2VybGl0eiBbbWFp
bHRvOmdlcmxpdHoub3JAZ21haWwuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxNCwg
MjAxNyAzOjE2IFBNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NCj4g
Q2M6IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT47IGxpbnV4LXJkbWFAdmdlci5r
ZXJuZWwub3JnOyBIZWZ0eSwNCj4gU2VhbiA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+OyBMZW9uIFJv
bWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggcmRt
YS1uZXh0IDI4LzMxXSBJQi9jbTogRml4IGF2b2lkIHNsZWVwIHdoaWxlIHNwaW4gbG9jayBpcw0K
PiBoZWxkDQo+IA0KPiBPbiBUdWUsIE5vdiAxNCwgMjAxNyBhdCAyOjUyIFBNLCBMZW9uIFJvbWFu
b3Zza3kgPGxlb25Aa2VybmVsLm9yZz4gd3JvdGU6DQo+ID4gRnJvbTogUGFyYXYgUGFuZGl0IDxw
YXJhdkBtZWxsYW5veC5jb20+DQo+ID4NCj4gPiBJbiBjYXNlIG9mIExBUCBhcmUgdXNlZCBmb3Ig
Um9DRQ0KPiANCj4gQUZBSUsgQVBNIGlzIG5vdCBzdXBwb3J0ZWQgd2l0aCBSb0NFLCBpc24ndCB0
aGF0PyBpZiB5ZXMsIG9uIHdoYXQgSFcvUm9DRQ0KPiBtb2RlIGFuZCBob3cgZG8geW91IHRlc3Qg
dGhhdD8NClRoaXMgcGFydGljdWxhciBwYXRjaCBpbiB0aGlzIHNlcmllcyBpcyBub3QgdGVzdGVk
IG9uIFJvQ0UuDQpBUE0gaXMgbm90IHN1cHBvcnRlZCBidXQgaW5qZWN0aW5nIHN1Y2ggZnJhbWUg
aW4gbmV0d29yayBpcyBub3QgaW1wb3NzaWJsZS4NCldlIGRvbuKAmXQgaGF2ZSBwYXJ0aWN1bGFy
IGNoZWNrcyB0byByZWplY3Qgc3VjaCBmcmFtZSBmb3IgUm9DRS4NClNvIEkgcHJlZmVyIHRvIGZp
eCB0aGUgaXNzdWUgYmVmb3JlIGdldHRpbmcgc3VjaCBoYW5nL29vcHMgcmVwb3J0IHdoZW4gaXNz
dWUgaXMgZXZpZGVudCBpbiBjb2RlLg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
