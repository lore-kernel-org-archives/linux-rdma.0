From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Mon, 12 Feb 2018 18:04:09 +0000
Message-ID: <1518458648.2668.11.camel@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
         <1516230870.3403.292.camel@redhat.com> <1517271807.2687.65.camel@wdc.com>
         <1517334206.27592.291.camel@redhat.com> <1517336389.2589.22.camel@wdc.com>
         <1517351373.19117.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517351373.19117.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <3429413365FAF24A9002D3C7CE56E307-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDE3OjI5IC0wNTAwLCBEb3VnIExlZGZvcmQgd3JvdGU6DQo+
IE9uIFR1ZSwgMjAxOC0wMS0zMCBhdCAxODoxOSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdyb3Rl
Og0KPiA+IFJlZ2FyZGluZyBjb25maWd1cmluZyBvbiB3aGljaCBJUCBhZGRyZXNzIHRvIGxpc3Rl
biwgb25lIHBvc3NpYmlsZSBhcHByb2FjaA0KPiA+IGlzIHRvIG1vdmUgdGhlIHJkbWFfY21fcG9y
dCBwb3J0IG51bWJlciBjb25maWdmcyBhdHRyaWJ1dGUgZnJvbQ0KPiA+IC9zeXMva2VybmVsL2Nv
bmZpZy90YXJnZXQvc3JwdC9kaXNjb3ZlcnlfYXV0aC9yZG1hX2NtX3BvcnQgdG8NCj4gPiAvc3lz
L2tlcm5lbC9jb25maWcvdGFyZ2V0L3NycHQvJHBvcnQvJHBvcnQvYXR0cmliL3JkbWFfY21fcG9y
dCB3aGVyZSAkcG9ydA0KPiA+IGlzIGFuIFJETUEgcG9ydCBHVUlEIG9yIEdJRCAoYm90aCBhcmUg
YWNjZXB0ZWQpLiBUaGF0IHdvdWxkIGFsbG93IHRvDQo+ID4gZW5hYmxlL2Rpc2FibGUgUkRNQS9D
TSBzdXBwb3J0IHBlciBSRE1BIGFkYXB0ZXIgcG9ydC4gVGhlIGliX3NycHQgZHJpdmVyDQo+ID4g
Y291bGQgZS5nLiBjcmVhdGUgb25lIGxpc3RlbmluZyByZG1hX2NtX2lkIHBlciBJUCBhZGRyZXNz
IHRoYXQgaXMgYXNzb2NpYXRlZA0KPiA+IHdpdGggYW4gUkRNQSBwb3J0Lg0KPiANCj4gVGhhdCB3
b3VsZCB3b3JrIGFzIHdlbGwuDQoNCkhlbGxvIERvdWcsDQoNCkRvIHlvdSBwcmVmZXIgdGhhdCB0
aGUgUkRNQS9DTSBwb3J0IG51bWJlciBpcyBjb25maWd1cmFibGUgcGVyIFJETUEgcG9ydA0KKC9z
eXMva2VybmVsL2NvbmZpZy90YXJnZXQvc3JwdC8kcG9ydC8kcG9ydC9hdHRyaWIvcmRtYV9jbV9w
b3J0KSBvciBpcyBhDQpzaW5nbGUgYXR0cmlidXRlIGZvciBhbGwgcG9ydHMgc3VmZmljaWVudA0K
KC9zeXMva2VybmVsL2NvbmZpZy90YXJnZXQvc3JwdC9kaXNjb3ZlcnlfYXV0aC9yZG1hX2NtX3Bv
cnQpPyBJJ20gYXNraW5nIHRoaXMNCnNpbmNlIHRoZXJlIGlzIGFscmVhZHkgYW4gYXR0cmlidXRl
IHRoYXQgYWxsb3dzIHRvIGVuYWJsZS9kaXNhYmxlIFNSUCB0YXJnZXQNCnN1cHBvcnQgcGVyIFJE
TUEgcG9ydCAoL3N5cy9rZXJuZWwvY29uZmlnL3RhcmdldC9zcnB0LyRwb3J0LyRwb3J0L2VuYWJs
ZSkuDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
