From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion
 queue pools
Date: Tue, 14 Nov 2017 16:28:07 +0000
Message-ID: <1510676885.2280.9.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <20171108095742.25365-2-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-2-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <19B91E6C07735640A89FB2F61C678D57-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE3LTExLTA4IGF0IDExOjU3ICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiArc3RydWN0IGliX2NxICppYl9maW5kX2dldF9jcShzdHJ1Y3QgaWJfZGV2aWNlICpkZXYsIHVu
c2lnbmVkIGludCBucl9jcWUsDQo+ICsgICAgICAgICAgICAgICBlbnVtIGliX3BvbGxfY29udGV4
dCBwb2xsX2N0eCwgaW50IGFmZmluaXR5X2hpbnQpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IGli
X2NxICpjcSwgKmZvdW5kOw0KPiArICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ICsgICAg
ICAgaW50IHZlY3RvciwgcmV0Ow0KPiArDQo+ICsgICAgICAgaWYgKHBvbGxfY3R4ID49IEFSUkFZ
X1NJWkUoZGV2LT5jcV9wb29scykpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gRVJSX1BUUigt
RUlOVkFMKTsNCj4gKw0KPiArICAgICAgIGlmICghaWJfZmluZF92ZWN0b3JfYWZmaW5pdHkoZGV2
LCBhZmZpbml0eV9oaW50LCAmdmVjdG9yKSkgew0KPiArICAgICAgICAgICAgICAgLyoNCj4gKyAg
ICAgICAgICAgICAgICAqIENvdWxkbid0IGZpbmQgbWF0Y2hpbmcgdmVjdG9yIGFmZmluaXR5IHNv
IHByb2plY3QNCj4gKyAgICAgICAgICAgICAgICAqIHRoZSBhZmZpbnR5IHRvIHRoZSBkZXZpY2Ug
Y29tcGxldGlvbiB2ZWN0b3IgcmFuZ2UNCj4gKyAgICAgICAgICAgICAgICAqLw0KPiArICAgICAg
ICAgICAgICAgdmVjdG9yID0gYWZmaW5pdHlfaGludCAlIGRldi0+bnVtX2NvbXBfdmVjdG9yczsN
Cj4gKyAgICAgICB9DQoNClNvIGRlcGVuZGluZyBvbiB3aGV0aGVyIG9yIG5vdCB0aGUgSENBIGRy
aXZlciBpbXBsZW1lbnRzIC5nZXRfdmVjdG9yX2FmZmluaXR5KCkNCmVpdGhlciBwY2lfaXJxX2dl
dF9hZmZpbml0eSgpIGlzIHVzZWQgb3IgInZlY3RvciA9IGFmZmluaXR5X2hpbnQgJQ0KZGV2LT5u
dW1fY29tcF92ZWN0b3JzIj8gU29ycnkgYnV0IEkgdGhpbmsgdGhhdCBraW5kIG9mIGRpZmZlcmVu
Y2VzIG1ha2VzIGl0DQp1bm5lY2Vzc2FyaWx5IGhhcmQgZm9yIFVMUCBtYWludGFpbmVycyB0byBw
cm92aWRlIHByZWRpY3RhYmxlIHBlcmZvcm1hbmNlIGFuZA0KY29uc2lzdGVudCBiZWhhdmlvciBh
Y3Jvc3MgSENBcy4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
