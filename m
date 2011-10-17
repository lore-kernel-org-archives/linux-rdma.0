From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [patch] RDMA/nes: silence compiler warning
Date: Mon, 17 Oct 2011 08:19:31 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904EC3E2BCB@azsmsx506.amr.corp.intel.com>
References: <20111017072857.GB7812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017072857.GB7812-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RGFuIENhcnBlbnRlciBXcm90ZToNCg0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxk
YW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZp
bmliYW5kL2h3L25lcy9uZXNfY20uYw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9uZXMvbmVz
X2NtLmMNCj4gaW5kZXggMTY2NjdjNy4uYjk2ZWM0MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9p
bmZpbmliYW5kL2h3L25lcy9uZXNfY20uYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcv
bmVzL25lc19jbS5jDQo+IEBAIC0zMTg5LDcgKzMxODksNyBAQCBpbnQgbmVzX2FjY2VwdChzdHJ1
Y3QgaXdfY21faWQgKmNtX2lkLCBzdHJ1Y3QNCj4gaXdfY21fY29ubl9wYXJhbSAqY29ubl9wYXJh
bSkNCj4gDQo+ICAJbmVzX2RlYnVnKE5FU19EQkdfQ00sICJRUCV1LCBEZXN0aW5hdGlvbiBJUCA9
IDB4JTA4WDoweCUwNFgsDQo+IGxvY2FsID0gIg0KPiAgCQkgICIweCUwOFg6MHglMDRYLCByY3Zf
bnh0PTB4JTA4WCwgc25kX254dD0weCUwOFgsIG1wYSArICINCj4gLQkJICAicHJpdmF0ZSBkYXRh
IGxlbmd0aD0lenUuXG4iLCBuZXNxcC0+aHdxcC5xcF9pZCwNCj4gKwkJICAicHJpdmF0ZSBkYXRh
IGxlbmd0aD0lZC5cbiIsIG5lc3FwLT5od3FwLnFwX2lkLA0KPiAgCQkgIG50b2hsKGNtX2lkLT5y
ZW1vdGVfYWRkci5zaW5fYWRkci5zX2FkZHIpLA0KPiAgCQkgIG50b2hzKGNtX2lkLT5yZW1vdGVf
YWRkci5zaW5fcG9ydCksDQo+ICAJCSAgbnRvaGwoY21faWQtPmxvY2FsX2FkZHIuc2luX2FkZHIu
c19hZGRyKSwNCg0KQWNrZWQtYnk6IEZhaXNhbCBMYXRpZiA8ZmFpc2FsLmxhdGlmQGludGVsLmNv
bT4NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
