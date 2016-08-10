From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Wed, 10 Aug 2016 19:07:12 +0000
Message-ID: <1470856029.9289.11.camel@intel.com>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
	 <20160809175801.GD23921@leon.nu>
	 <20160810053549.GA32695@phlsvsds.ph.intel.com>
	 <20160810055138.GH23921@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160810055138.GH23921-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Content-ID: <B935E4D4EAEE2142A65E7EB7452D13D7-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hariharan, Easwar" <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE2LTA4LTEwIGF0IDA4OjUxICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFdlZCwgQXVnIDEwLCAyMDE2IGF0IDAxOjM1OjUwQU0gLTA0MDAsIGlyYS53ZWlueSB3
cm90ZToNCj4gPiBPbiBUdWUsIEF1ZyAwOSwgMjAxNiBhdCAwODo1ODowMVBNICswMzAwLCBMZW9u
IFJvbWFub3Zza3kgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIEF1ZyAwOSwgMjAxNiBhdCAxMToxNzox
OEFNIC0wNDAwLCBpcmEud2VpbnlAaW50ZWwuY29tDQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gRnJv
bTogRWFzd2FyIEhhcmloYXJhbiA8ZWFzd2FyLmhhcmloYXJhbkBpbnRlbC5jb20+DQo+ID4gPiA+
IA0KPiA+ID4gPiBUaGUgbW9uaXRvciB2YWx1ZXMgZnJvbSBieXRlcyAyMiB0aHJvdWdoIDgxIG9m
IHRoZSBRU0ZQIG1lbW9yeQ0KPiA+ID4gPiBzcGFjZQ0KPiA+ID4gPiAoU0ZGIDg2MzYpIGFyZSBk
eW5hbWljIGFuZCBzZXJ2aW5nIHRoZW0gb3V0IG9mIHRoZSBRU0ZQIG1lbW9yeQ0KPiA+ID4gPiBj
YWNoZQ0KPiA+ID4gPiBtYWludGFpbmVkIGJ5IHRoZSBkcml2ZXIgcHJvdmlkZXMgc3RhbGUgZGF0
YSB0byB0aGUgQ2FibGVJbmZvDQo+ID4gPiA+IFNNQSBxdWVyeS4NCj4gPiA+ID4gVGhpcyBwYXRj
aCByZWZyZXNoZXMgdGhlIGR5bmFtaWMgdmFsdWVzIGZyb20gdGhlIFFTRlAgbWVtb3J5IG9uDQo+
ID4gPiA+IHJlcXVlc3QNCj4gPiA+ID4gYW5kIG92ZXJ3cml0ZXMgdGhlIHN0YWxlIGRhdGEgZnJv
bSB0aGUgY2FjaGUgZm9yIHRoZSBvdmVybGFwDQo+ID4gPiA+IGJldHdlZW4gdGhlDQo+ID4gPiA+
IHJlcXVlc3RlZCByYW5nZSBhbmQgdGhlIG1vbml0b3IgcmFuZ2UuDQo+ID4gPiA+IA0KPiA+ID4g
PiANCj4gPiA+IA0KPiA+ID4gSXJhLA0KPiA+ID4gT24gYWxsIHlvdXIgcGF0Y2hlcywgeW91IGhh
dmUgZG91YmxlIGxpbmUgYmV0d2VlbiBjb21taXQgbWVzc2FnZQ0KPiA+ID4gYW5kDQo+ID4gPiB0
YWdzLg0KPiA+IA0KPiA+IERvZXMgdGhpcyBjYXVzZSBhIHByb2JsZW0/DQo+IA0KPiBQcm9ibGVt
IC0gbm8sIGluY29udmVuaWVuY2UgLSB5ZXMuDQo+IEl0IGRvZXNuJ3QgbG9vayBwcmV0dHkgaW4g
Z2l0IGhpc3RvcnkuDQoNCldlJ2xsIGNhdGNoIGl0IG5leHQgdGltZT8gTm90IHdvcnRoIHJlc3Vi
bWl0dGluZyBJIGRvbid0IHRoaW5rLg0KDQotRGVubnk=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
