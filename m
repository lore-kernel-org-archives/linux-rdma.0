From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error,
 also mark the CQs in error.
Date: Wed, 20 Oct 2010 15:41:33 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FCA3@orsmsx501.amr.corp.intel.com>
References: <20101020214432.4869.50981.stgit@build.ogc.int>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FC1F@orsmsx501.amr.corp.intel.com>
 <4CBF6F3F.10507@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBF6F3F.10507-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

WW91IGhhdmUgdGhpcyBjaGVjazoNCg0KPiA+PiArCQlpZiAodWRhdGEtPm91dGxlbjwgIHNpemVv
ZiB1cmVzcCkgew0KPiA+PiArCQkJaWYgKCF3YXJuZWQrKykNCj4gPj4gKwkJCQlwcmludGsoS0VS
Tl9XQVJOSU5HIE1PRCAiV2FybmluZyAtICINCj4gPj4gKwkJCQkgICAgICAgImRvd25sZXZlbCBs
aWJjeGdiMyAobm9uLWZhdGFsKS5cbiIpOw0KPiA+PiArCQkJbW0tPmxlbiA9IFBBR0VfQUxJR04o
KDFVTDw8ICB1cmVzcC5zaXplX2xvZzIpICoNCj4gPj4gKwkJCQkJICAgICBzaXplb2Yoc3RydWN0
IHQzX2NxZSkpOw0KDQp0aGVuIGZhbGwgdGhyb3VnaCB0byBoZXJlOg0KDQo+ID4+ICAgCQlpZiAo
aWJfY29weV90b191ZGF0YSh1ZGF0YSwmdXJlc3AsIHNpemVvZiAodXJlc3ApKSkgew0KDQoNCj4g
VGhlIG9ubHkgd2F5IGl0IGNhbiBiZSBsZXNzIGlzIGlmIHRoZSBsaWJyYXJ5IGlzIHVzaW5nIHRo
ZSBBQkkgMCB2ZXJzaW9uDQo+IG9mIHRoZSByZXNwb25zZSBzdHJ1Y3QuICBPciBhbSBJIG1pc3Np
bmcgc29tZXRoaW5nPw0KDQpUbyBtZSwgdGhpcyBsb29rcyBsaWtlIHRoZSBidWZmZXIgcmVmZXJl
bmNlZCBieSB1ZGF0YSB3aWxsIGJlIHNtYWxsZXIgdGhhbiB0aGUgc2l6ZSBvZiB0aGUgZGF0YSBi
ZWluZyBjb3BpZWQsIHdoaWNoIEkgZXhwZWN0IHdvdWxkIGVpdGhlciBmYWlsLCBvciB0aGUga2Vy
bmVsIHdpbGwgb3ZlcndyaXRlIHNvbWUgdW5zdXNwZWN0aW5nIHVzZXIgbWVtb3J5Lg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
