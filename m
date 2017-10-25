From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 3/3] ibacm: In acm_util.c:acm_if_iter_sys, try
 IPv4 if IPv6 doesn't find any appropriate interfaces
Date: Wed, 25 Oct 2017 15:35:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1A2521@ORSMSX109.amr.corp.intel.com>
References: <8d19d9a9-1f97-408e-ca60-d42e67fbf60c@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB1A24BB@ORSMSX109.amr.corp.intel.com>
 <cb3ecc66-d128-e735-4bc7-c35aca3fa915@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cb3ecc66-d128-e735-4bc7-c35aca3fa915-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+PiBAQCAtMTM1LDkgKzEzNiwxMiBAQCBpbnQgYWNtX2lmX2l0ZXJfc3lzKGFjbV9pZl9pdGVy
X2NiIGNiLCB2b2lkDQo+ID4+ICpjdHgpDQo+ID4+ICAJc2l6ZV90IGFkZHJfbGVuOw0KPiA+PiAg
CWNoYXIgKmFsaWFzX3NlcDsNCj4gPj4NCj4gPj4gLQlzID0gc29ja2V0KEFGX0lORVQ2LCBTT0NL
X0RHUkFNLCAwKTsNCj4gPj4gLQlpZiAoIXMpDQo+ID4+IC0JCXJldHVybiAtMTsNCj4gPj4gK25l
eHRfZmFtaWx5Og0KPiA+PiArCXMgPSBzb2NrZXQoZmFtaWx5LCBTT0NLX0RHUkFNLCAwKTsNCj4g
Pj4gKwlpZiAoIXMpIHsNCj4gPg0KPiA+IElmIGlwdjYgaXMgZGlzYWJsZWQsIHdvdWxkbid0IHdl
IGZhaWwgaGVyZSBhbmQgY291bGQgb3BlbiBhbiBpcHY0DQo+IHNvY2tldD8gIFNvLCB3ZSBkb24n
dCBnb3RvIG91dCBqdXN0IHRvIGdvIGJhY2sgdG8gdGhpcyBsb2NhdGlvbj8NCj4gDQo+IEluIHRo
ZSBjYXNlIHdoZXJlIGlwdjYgaXMgZGlzYWJsZWQgaW4ga2VybmVsLCB0aGUgc29ja2V0IGlzIGNy
ZWF0ZWQNCj4gYnV0IHRoZSBpb2N0bCBmYWlsZWQuDQoNClRoYXQgc2VlbXMgZ29vZnkgSU1PLiAg
VGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24gdGhvdWdoLiAgOikNCg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
