From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error,
	also mark the CQs in error.
Date: Wed, 20 Oct 2010 15:10:09 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FC1F@orsmsx501.amr.corp.intel.com>
References: <20101020214432.4869.50981.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020214432.4869.50981.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBAQCAtMjE3LDE1ICsyMTgsMjQgQEAgc3RhdGljIHN0cnVjdCBpYl9jcSAqaXdjaF9jcmVhdGVf
Y3Eoc3RydWN0IGliX2RldmljZQ0KPiAqaWJkZXYsIGludCBlbnRyaWVzLCBpbnQgdmUNCj4gIAkJ
dXJlc3Aua2V5ID0gdWNvbnRleHQtPmtleTsNCj4gIAkJdWNvbnRleHQtPmtleSArPSBQQUdFX1NJ
WkU7DQo+ICAJCXNwaW5fdW5sb2NrKCZ1Y29udGV4dC0+bW1hcF9sb2NrKTsNCj4gKwkJbW0tPmtl
eSA9IHVyZXNwLmtleTsNCj4gKwkJbW0tPmFkZHIgPSB2aXJ0X3RvX3BoeXMoY2hwLT5jcS5xdWV1
ZSk7DQo+ICsJCWlmICh1ZGF0YS0+b3V0bGVuIDwgc2l6ZW9mIHVyZXNwKSB7DQo+ICsJCQlpZiAo
IXdhcm5lZCsrKQ0KPiArCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgTU9EICJXYXJuaW5nIC0gIg0K
PiArCQkJCSAgICAgICAiZG93bmxldmVsIGxpYmN4Z2IzIChub24tZmF0YWwpLlxuIik7DQo+ICsJ
CQltbS0+bGVuID0gUEFHRV9BTElHTigoMVVMIDw8IHVyZXNwLnNpemVfbG9nMikgKg0KPiArCQkJ
CQkgICAgIHNpemVvZihzdHJ1Y3QgdDNfY3FlKSk7DQo+ICsJCX0gZWxzZSB7DQo+ICsJCQltbS0+
bGVuID0gUEFHRV9BTElHTigoKDFVTCA8PCB1cmVzcC5zaXplX2xvZzIpICsgMSkgKg0KPiArCQkJ
CQkgICAgIHNpemVvZihzdHJ1Y3QgdDNfY3FlKSk7DQo+ICsJCQl1cmVzcC5tZW1zaXplID0gbW0t
PmxlbjsNCj4gKwkJfQ0KPiAgCQlpZiAoaWJfY29weV90b191ZGF0YSh1ZGF0YSwgJnVyZXNwLCBz
aXplb2YgKHVyZXNwKSkpIHsNCg0KSXMgdGhpcyBjb3JyZWN0PyAgdWRhdGEtPm91dGxlbiBjYW4g
YmUgbGVzcyB0aGFuIHNpemVvZiB1cmVzcCBoZXJlLg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
