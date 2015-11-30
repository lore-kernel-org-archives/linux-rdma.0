From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/core: correct issue with sge copyin corrupting wr
Date: Mon, 30 Nov 2015 22:31:58 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259C322E@fmsmsx120.amr.corp.intel.com>
References: <CAJ3xEMjqcvfe6Gvt5Ctee354RotRXCw8BATWTv2+zgpodGhMOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjqcvfe6Gvt5Ctee354RotRXCw8BATWTv2+zgpodGhMOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBCZWluZyBhIG5vbiBuYXRpdmUgRW5nbGlzaCBzcGVha2VyIEkgYW0gbm90IGZ1bGx5IHN1cmUs
IGJ1dCAiY29weWluDQo+IGNvcnJ1cHRpbmciIHNvdW5kcyBsaWtlIHNsYW5nIC8gc3RyZWV0IHRh
bGtpbmcuLi4gcHJvcGVyIEVuZ2xpc2ggcGxlYXNlDQo+IA0KPiA+IENvbW1pdCBlNjIyZjJmNGFk
MjEgKCJJQjogc3BsaXQgc3RydWN0IGliX3NlbmRfd3IiKSBpbnRyb2R1Y2VkIGENCj4gPiByZWdy
ZXNzaW9uIGZvciBIQ0FzIHdob3NlIHVzZXIgbW9kZSBwb3N0IHNlbmRzIGdvIHRocm91Z2gNCj4g
PiBpYl91dmVyYnNfcG9zdF9zZW5kKCkuDQo+ID4NCj4gPiBUaGUgY29kZSBkaWRuJ3QgYWNjb3Vu
dCBmb3IgdGhlIGZhY3QgdGhhdCB0aGUgZmlyc3Qgc2dlIGlzIG9mZnNldCBieQ0KPiA+IGFuIG9w
ZXJhdGlvbiBkZXBlbmRlbnQgbGVuZ3RoLiAgVGhlIGFsbG9jYXRpb24gZGlkLCBidXQgdGhlIHBv
aW50ZXIgdG8NCj4gPiB0aGUgc2dlIGxpc3QgaXMgY29tcHV0ZWQgd2l0aG91dCB0aGF0IGtub3ds
ZWRnZS4NCj4gPg0KPiA+IFN0b3JlIHRoZSBvcGVyYXRpb24gZGVwZW5kZW50IGxlbmd0aCBpbiBh
biBhdXRvbWF0aWMgYW5kIGNvbXB1dGUgdGhlDQo+ID4gc2dlIGxpc3QgY29weSBpbiBkZXN0aW5h
dGlvbiB1c2luZyB0aGF0IGxlbmd0aC4NCj4gDQo+IGluIGFuIGF1dG9tYXRpYyB3aGF0Pw0KDQpT
ZWUgaHR0cDovL21hcmMuaW5mby8/bD1saW51eC1yZG1hJm09MTQ0ODkyMjI0MTE4NDA2Jnc9Mi4N
Cg0KTWlrZQ0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
