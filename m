From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/cma: Fix net_dev reference leak with failed requests
Date: Mon, 31 Aug 2015 15:20:57 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CB7D78D@CRSMSX101.amr.corp.intel.com>
References: <1440680115-9164-1-git-send-email-haggaie@mellanox.com>
 <CAJ3xEMhtnzHu23wnpsHex5_xt3MV=z3ERoX6T5d=RoTVdOVrpw@mail.gmail.com>
 <55E382CF.9040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E382CF.9040506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiANCj4gT24gMDgvMzAvMjAxNSAwMjoxMiBBTSwgT3IgR2VybGl0eiB3cm90ZToNCj4gPiBPbiBU
aHUsIEF1ZyAyNywgMjAxNSBhdCA1OjU1IEFNLCBIYWdnYWkgRXJhbiA8aGFnZ2FpZUBtZWxsYW5v
eC5jb20+DQo+IHdyb3RlOg0KPiA+PiBXaGVuIG5vIG1hdGNoaW5nIGxpc3RlbmluZyBJRCBpcyBm
b3VuZCBmb3IgYSBnaXZlbiByZXF1ZXN0LCB0aGUNCj4gPj4gbmV0X2RldiB0aGF0IHdhcyB1c2Vk
IHRvIGZpbmQgdGhlIHJlcXVlc3QgaXNuJ3QgcmVsZWFzZWQuDQo+ID4+DQo+ID4+IEZpeGVzOiAy
MGMzNjgzNmVjYWQgKCJJQi9jbWE6IFVzZSBmb3VuZCBuZXRfZGV2IGZvciBwYXNzaXZlDQo+ID4+
IGNvbm5lY3Rpb25zIikNCj4gPg0KPiA+IHNhbWUgaGVyZSwgRG91ZywNCj4gDQo+IFNhbWUgYXMg
dGhlIGxhc3QgZW1haWwsIEkgaGF2ZSB0aGUgY29tbWl0IElEIG5vdywgYW5kIEkgZml4ZWQgdXAg
dGhlIGNvbW1pdA0KPiBtZXNzYWdlLg0KPiANCg0KRG91ZyBJJ20gd29ya2luZyBvbiB0aGUgY2xl
YW4gdXAgSGFsIHN1Z2dlc3RlZCB0byB0aGUgaWJfbWFkLmggZmlsZSB3aGljaCB3YXMgdXBkYXRl
ZCBpbiB5b3VyIHRvLWJlLXJlYmFzZWQtNC4zIGJyYW5jaCB2aWEgdGhpcyBwYXRjaC4NCg0KRml4
ZXM6IGFiZGUwMjYwZTQ3YiAoIklCL2NvcmU6IEFkZCBoZWFkZXIgZGVmaW5pdGlvbnMiKQ0KDQpJ
dCBsb29rcyBsaWtlIHRoaXMgaXMgdGhlIHBhdGNoIGRlc3RpbmVkIGZvciA0LjMgb24gdGhpcyBi
cmFuY2ggay5vL2Zvci00LjM/DQoNCkZpeGVzOiBkNGFiMzQ3MDA1ZmIgKCJJQi9jb3JlOiBBZGQg
Y29yZSBoZWFkZXIgY2hhbmdlcyBuZWVkZWQgZm9yIE9QQSIpDQoNCkkgcGVyc29uYWxseSBkaWQg
bm90IG1pbmQgdGhlIHJlYmFzaW5nIGV4Y2VwdCBmb3IgdGhpcyBpc3N1ZS4NCg0KTGV0IG1lIGtu
b3cgd2hpY2ggYnJhbmNoIEkgc2hvdWxkIGJhc2UgdGhlc2UgY2hhbmdlcyBvZmYgb2YuDQoNClRo
YW5rcywNCklyYQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
