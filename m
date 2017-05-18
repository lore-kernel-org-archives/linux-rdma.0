From: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [infiniband-hw-i40iw] question about identical code for
 different branches
Date: Thu, 18 May 2017 14:35:33 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A730338947@fmsmsx116.amr.corp.intel.com>
References: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQo+IFN1YmplY3Q6IFtpbmZpbmliYW5kLWh3LWk0MGl3XSBxdWVzdGlvbiBhYm91dCBpZGVudGlj
YWwgY29kZSBmb3IgZGlmZmVyZW50IGJyYW5jaGVzDQo+IA0KPiANCj4gaW5kZXggZjRkMTM2OC4u
NDhmZDMyNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2k0MGl3L2k0MGl3
X3ZpcnRjaG5sLmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2k0MGl3L2k0MGl3X3Zp
cnRjaG5sLmMNCj4gQEAgLTQ0MywxMCArNDQzLDcgQEAgZW51bSBpNDBpd19zdGF0dXNfY29kZSBp
NDBpd192Y2hubF9yZWN2X3BmKHN0cnVjdA0KPiBpNDBpd19zY19kZXYgKmRldiwNCj4gICAgICAg
ICAgaWYgKCFkZXYtPnZjaG5sX3VwKQ0KPiAgICAgICAgICAgICAgICAgIHJldHVybiBJNDBJV19F
UlJfTk9UX1JFQURZOw0KPiAgICAgICAgICBpZiAodmNobmxfbXNnLT5pd19vcF9jb2RlID09IEk0
MElXX1ZDSE5MX09QX0dFVF9WRVIpIHsNCj4gLSAgICAgICAgICAgICAgIGlmICh2Y2hubF9tc2ct
Pml3X29wX3ZlciAhPSBJNDBJV19WQ0hOTF9PUF9HRVRfVkVSX1YwKQ0KPiAtICAgICAgICAgICAg
ICAgICAgICAgICB2Y2hubF9wZl9zZW5kX2dldF92ZXJfcmVzcChkZXYsIHZmX2lkLCB2Y2hubF9t
c2cpOw0KPiAtICAgICAgICAgICAgICAgZWxzZQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICB2
Y2hubF9wZl9zZW5kX2dldF92ZXJfcmVzcChkZXYsIHZmX2lkLCB2Y2hubF9tc2cpOw0KPiArICAg
ICAgICAgICAgICAgdmNobmxfcGZfc2VuZF9nZXRfdmVyX3Jlc3AoZGV2LCB2Zl9pZCwgdmNobmxf
bXNnKTsNCj4gICAgICAgICAgICAgICAgICByZXR1cm4gSTQwSVdfU1VDQ0VTUzsNCj4gICAgICAg
ICAgfQ0KPiAgICAgICAgICBmb3IgKGl3X3ZmX2lkeCA9IDA7IGl3X3ZmX2lkeCA8IEk0MElXX01B
WF9QRV9FTkFCTEVEX1ZGX0NPVU5UOw0KPiBpd192Zl9pZHgrKykgew0KPiANCj4gV2hhdCBkbyB5
b3UgdGhpbms/DQo+IA0KPiBJJ2QgcmVhbGx5IGFwcHJlY2lhdGUgYW55IGNvbW1lbnQgb24gdGhp
cy4NCj4gDQpZZXMuIFRoaXMgZml4IGlzIGZpbmUuDQoNClNoaXJheg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
