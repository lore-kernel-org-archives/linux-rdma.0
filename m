From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Mon, 15 Jun 2015 17:22:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF57D3@ORSMSX109.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
	<20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+ICtpbnQgX19pbml0IGRldl9pbml0KHZvaWQpDQo+ID4gK3sNCj4gPiArICAgICAgIGludCBy
ZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0ID0gYWxsb2NfY2hyZGV2X3JlZ2lvbigmaGZpMV9k
ZXYsIDAsIEhGSTFfTk1JTk9SUywNCj4gRFJJVkVSX05BTUUpOw0KPiA+ICsgICAgICAgaWYgKHJl
dCA8IDApIHsNCj4gPiArICAgICAgICAgICAgICAgcHJfZXJyKCJDb3VsZCBub3QgYWxsb2NhdGUg
Y2hyZGV2IHJlZ2lvbiAoZXJyICVkKVxuIiwgLQ0KPiByZXQpOw0KPiA+ICsgICAgICAgICAgICAg
ICBnb3RvIGRvbmU7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgY2xhc3MgPSBj
bGFzc19jcmVhdGUoVEhJU19NT0RVTEUsIGNsYXNzX25hbWUoKSk7DQo+ID4gKyAgICAgICBpZiAo
SVNfRVJSKGNsYXNzKSkgew0KPiA+ICsgICAgICAgICAgICAgICByZXQgPSBQVFJfRVJSKGNsYXNz
KTsNCj4gPiArICAgICAgICAgICAgICAgcHJfZXJyKCJDb3VsZCBub3QgY3JlYXRlIGRldmljZSBj
bGFzcyAoZXJyICVkKVxuIiwgLQ0KPiByZXQpOw0KPiA+ICsgICAgICAgICAgICAgICB1bnJlZ2lz
dGVyX2NocmRldl9yZWdpb24oaGZpMV9kZXYsIEhGSTFfTk1JTk9SUyk7DQo+ID4gKyAgICAgICB9
DQo+ID4gKw0KPiA+ICtkb25lOg0KPiA+ICsgICAgICAgcmV0dXJuIHJldDsNCj4gPiArfQ0KPiAN
Cj4gc28gd2hhdCdzIHRoZSByb2xlIG9mIHRoZSBjaGFyLWRldmljZT8gDQoNClNvbWVvbmUgZnJv
bSBNaWtlJ3MgdGVhbSBjYW4gY2hpbWUgaW4sIGJ1dCBJIGJlbGlldmUgdGhpcyBzdXBwb3J0cyBu
b24tdmVyYnMgaW50ZXJmYWNlcyAoaS5lLiBQU00pLCBzaW1pbGFyIHRvIHdoYXQncyBkb25lIGZv
ciBxaWIuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
