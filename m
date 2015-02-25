From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 06/19] IB/core: Add max_mad_size to ib_device_attr
Date: Wed, 25 Feb 2015 18:13:35 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC3ECE5@CRSMSX101.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
	 <1423092585-26692-7-git-send-email-ira.weiny@intel.com>
 <1424787385.4847.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424787385.4847.16.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWQuYw0KPiA+IGIvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMgaW5kZXggODE5Yjc5NC4uYTZhMzNjZiAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWQuYw0KPiA+ICsrKyBiL2RyaXZl
cnMvaW5maW5pYmFuZC9jb3JlL21hZC5jDQo+ID4gQEAgLTI5MjQsNiArMjkyNCwxMiBAQCBzdGF0
aWMgaW50IGliX21hZF9wb3J0X29wZW4oc3RydWN0IGliX2RldmljZQ0KPiAqZGV2aWNlLA0KPiA+
ICAJY2hhciBuYW1lW3NpemVvZiAiaWJfbWFkMTIzIl07DQo+ID4gIAlpbnQgaGFzX3NtaTsNCj4g
Pg0KPiA+ICsJaWYgKGRldmljZS0+Y2FjaGVkX2Rldl9hdHRycy5tYXhfbWFkX3NpemUgPCBJQl9N
R01UX01BRF9TSVpFKSB7DQo+ID4gKwkJZGV2X2VycigmZGV2aWNlLT5kZXYsICJNaW4gTUFEIHNp
emUgZm9yIGRldmljZSBpcyAldVxuIiwNCj4gPiArCQkJSUJfTUdNVF9NQURfU0laRSk7DQo+ID4g
KwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKwl9DQo+ID4gKw0KPiANCj4gVGhlIHByaW50ayBtZXNz
YWdlIGhlcmUgaXMgbm90IHZlcnkgaW5mb3JtYXRpdmUgYW5kIGl0IHF1YWxpZmllcyBhcyBhbiBl
cnJvci4NCj4gU29tZW9uZSByZWFkaW5nIHRoYXQgZm9yIHRoZSBmaXJzdCB0aW1lIGluIHRoZSBk
bWVzZyBvdXRwdXQgYW5kIHdvbmRlcmluZw0KPiB3aHkgdGhlaXIgZGV2aWNlIGlzbid0IHdvcmtp
bmcgd2lsbCBiZSBjb25mdXNlZCBpZiB0aGV5IGRvbid0IGtub3cgYWJvdXQgdGhlDQo+IG1hZCBz
aXplIGNoYW5nZXMgeW91IGFyZSBtYWtpbmcgaGVyZS4gIFNvbWV0aGluZyBsaWtlICJtYXggc3Vw
cG9ydGVkIE1BRA0KPiBzaXplICgldSkgPCBtaW4gcmVxdWlyZWQgYnkgaWJfbWFkICgldSksIGln
bm9yaW5nIGRldiBcbiINCg0KR29vZCBzdWdnZXN0aW9uLg0KDQpGaXhlZCBmb3IgdjUgd2l0aCB0
aGlzIG1lc3NhZ2UuDQoNCisgICAgICAgICAgICAgICBkZXZfZXJyKCZkZXZpY2UtPmRldiwNCisg
ICAgICAgICAgICAgICAgICAgICAgICJNYXggc3VwcG9ydGVkIE1BRCBzaXplICgldSkgPCBtaW4g
cmVxdWlyZWQgYnkgaWJfbWFkICgldSksIGlnbm9yaW5nIGRldmljZSAoJXMpXG4iLA0KKyAgICAg
ICAgICAgICAgICAgICAgICAgZGV2aWNlLT5jYWNoZWRfZGV2X2F0dHJzLm1heF9tYWRfc2l6ZSwN
CisgICAgICAgICAgICAgICAgICAgICAgIElCX01HTVRfTUFEX1NJWkUsIGRldmljZS0+bmFtZSk7
DQoNCg0KSXJhDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
