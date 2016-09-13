From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: free the userspace memory region with kfree
 instead of vfree
Date: Tue, 13 Sep 2016 12:44:28 +0000
Message-ID: <1473770664.1004.10.camel@intel.com>
References: <20160909071537.18821-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909071537.18821-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Content-ID: <F3F31BC32BAA9F4A8DD747A3E1D1FF54-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE2LTA5LTA5IGF0IDA4OjE1ICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
IHVzZXJzcGFjZSBtZW1vcnkgcmVnaW9uICdtcicgaXMgYWxsb2NhdGVkIHdpdGgga3phbGxvYyBp
bg0KPiBfX3J2dF9hbGxvY19tcsKgwqBob3dldmVyIGl0IGlzIGluY29ycmVjdGx5IGJlaW5nIGZy
ZWVkIHdpdGggdmZyZWUgaW4NCj4gX19ydnRfZnJlZV9tci4gRml4IHRoaXMgYnkgdXNpbmcga2Zy
ZWUgdG8gZnJlZSBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xp
bi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvaW5maW5pYmFuZC9zdy9y
ZG1hdnQvbXIuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvc3cvcmRt
YXZ0L21yLmMNCj4gYi9kcml2ZXJzL2luZmluaWJhbmQvc3cvcmRtYXZ0L21yLmMNCj4gaW5kZXgg
ODBjNGI2Yi4uNDZiNjQ5NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL3N3L3Jk
bWF2dC9tci5jDQo+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQvbXIuYw0KPiBA
QCAtMjk0LDcgKzI5NCw3IEBAIHN0YXRpYyB2b2lkIF9fcnZ0X2ZyZWVfbXIoc3RydWN0IHJ2dF9t
ciAqbXIpDQo+IMKgew0KPiDCoAlydnRfZGVpbml0X21yZWdpb24oJm1yLT5tcik7DQo+IMKgCXJ2
dF9mcmVlX2xrZXkoJm1yLT5tcik7DQo+IC0JdmZyZWUobXIpOw0KPiArCWtmcmVlKG1yKTsNCj4g
wqB9DQo+IMKgDQo+IMKgLyoqDQoNClRoYW5rcyENCg0KQWNrZWQtYnk6IERlbm5pcyBEYWxlc3Nh
bmRybyA8ZGVubmlzLmRhbGVzc2FuZHJvQGludGVsLmNvbT4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
