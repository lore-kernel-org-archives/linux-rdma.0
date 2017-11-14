From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default
 GID when IPv6 is disabled
Date: Tue, 14 Nov 2017 22:17:32 +0000
Message-ID: <VI1PR0502MB30087D6AA864A12D4922070ED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-2-leon@kernel.org>
 <CAJ3xEMgZBzak5V68AV4VFsPgrKOueXcCduHWBJQ-j=1+TBT+iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgZBzak5V68AV4VFsPgrKOueXcCduHWBJQ-j=1+TBT+iA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT3IgR2VybGl0eiBbbWFp
bHRvOmdlcmxpdHoub3JAZ21haWwuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxNCwg
MjAxNyAzOjI1IFBNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NCj4g
Q2M6IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT47IGxpbnV4LXJkbWFAdmdlci5r
ZXJuZWwub3JnOyBMZW9uDQo+IFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggcmRtYS1uZXh0IDAxLzMxXSBJQi9jb3JlOiBGaXggZG8gbm90IGFk
ZCBSb0NFdjIgZGVmYXVsdA0KPiBHSUQgd2hlbiBJUHY2IGlzIGRpc2FibGVkDQo+IA0KPiBPbiBU
dWUsIE5vdiAxNCwgMjAxNyBhdCAyOjUxIFBNLCBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVs
Lm9yZz4gd3JvdGU6DQo+ID4gRnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+
DQo+IA0KPiBEaWQgeW91IHdhbnQgdG8gc2F5ICJJQi9jb3JlOiBEbyBub3QgYWRkIFJvQ0V2MiBk
ZWZhdWx0IEdJRCB3aGVuIElQdjYgaXMNCj4gZGlzYWJsZWQiIChpLmUgcmVtb3ZlIHRoZSB3b3Jk
ICJGaXgiIGFuZCBDYXAgdGhlICJkbyIpDQpTb3VuZHMgZ29vZC4gRWl0aGVyIHdlIGNhbiBkbyB2
MSBvciBEb3VnIGNhbiBjaGFuZ2Ugd2hpbGUgbWVyZ2luZyBkZXBlbmRpbmcgb24gY29tbWVudHMg
b24gb3RoZXIgcGF0Y2hlcy4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
