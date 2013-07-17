From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] RDMA/cma: silence GCC warning
Date: Wed, 17 Jul 2013 18:07:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805B8318@ORSMSX109.amr.corp.intel.com>
References: <1373886239.2591.26.camel@x61.thuisdomein>
	 <1828884A29C6694DAF28B7E6B8A82373805A65C0@ORSMSX110.amr.corp.intel.com>
 <1374050453.26384.41.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374050453.26384.41.camel-uMdlDhfIn7prKue/0VVhAg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBCdWlsZGluZyBjbWEubyB0cmlnZ2VycyB0aGlzIEdDQyB3YXJuaW5nOg0KPiAgICAgZHJpdmVy
cy9pbmZpbmliYW5kL2NvcmUvY21hLmM6IEluIGZ1bmN0aW9uIOKAmHJkbWFfcmVzb2x2ZV9hZGRy
4oCZOg0KPiAgICAgZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmM6NDY1OjIzOiB3YXJuaW5n
OiDigJhwb3J04oCZIG1heSBiZSB1c2VkDQo+IHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlv
biBbLVdtYXliZS11bmluaXRpYWxpemVkXQ0KPiAgICAgZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
Y21hLmM6NDI2OjU6IG5vdGU6IOKAmHBvcnTigJkgd2FzIGRlY2xhcmVkIGhlcmUNCj4gDQo+IFRo
aXMgaXMgYSBmYWxzZSBwb3NpdGl2ZSwgYXMgInBvcnQiIHdpbGwgYWx3YXlzIGJlIGluaXRpYWxp
emVkIGlmIHdlJ3JlDQo+IGF0ICJmb3VuZCIuIEJ1dCBpZiB3ZSBhc3NpZ24gdG8gImlkX3ByaXYt
PmlkLnBvcnRfbnVtIiBkaXJlY3RseSwgd2UgY2FuDQo+IGRyb3AgInBvcnQiLiBUaGF0IHdpbGws
IG9idmlvdXNseSwgc2lsZW5jZSBHQ0MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYXVsIEJvbGxl
IDxwZWJvbGxlQHRpc2NhbGkubmw+DQoNCkFja2VkLWJ5OiBTZWFuIEhlZnR5IDxzZWFuLmhlZnR5
QGludGVsLmNvbT4NCg0KPiAtLS0NCj4gMCkgdjI6IGFzc2lnbiB0byAiaWRfcHJpdi0+aWQucG9y
dF9udW0iIGRpcmVjdGx5LCBpbnN0ZWFkIG9mDQo+IGluaXRpYWxpemluZyAicG9ydCIgdG8gMCwg
YXMgZGlzY3Vzc2VkIHdpdGggU2Vhbi4NCj4gDQo+IDEpIFN0aWxsIG9ubHkgY29tcGlsZSB0ZXN0
ZWQuDQoNCnRlc3RlZCAtIHRoYW5rcw0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
