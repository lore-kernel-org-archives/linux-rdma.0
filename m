From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Fri, 8 May 2015 20:06:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FCD719@ORSMSX109.amr.corp.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <1431111412.2407.463.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431111412.2407.463.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGlzIGlzIHdoYXQgSSBoYXZlIHNvIGZhcjoNCj4gDQo+IE9uIGEgcGVyIGRldmljZSBiYXNp
czogbm90IG11Y2ggdG8gYmUgaG9uZXN0LCBub2RlX3R5cGUgSUJfQ0EvUk5JQyBmb3INCj4gYmFj
ayBjb21wYXRpYmlsaXR5IGFuZCB0aGF0J3MgcHJldHR5IG11Y2ggaXQNCj4gDQo+IE9uIGEgcGVy
IHBvcnQgYmFzaXM6IGxpbmsgbGF5ZXIgKEV0aGVybmV0LCBJQiwgb3IgT1BBKS4gIE5vdGljZSB0
aGF0IEkNCj4gZGlkbid0IGluY2x1ZGUgdGhlIHRyYW5zcG9ydCBoZXJlLiAgVHdvIG9mIHRoZSBh
Ym92ZSBsaW5rIGxheWVycw0KPiBzdHJpY3RseSBpbXBseSB0aGVpciB0cmFuc3BvcnQuICBUaGUg
dGhpcmQgbGluayBsYXllciBjb3VsZCBoYXZlDQo+IG11bHRpcGxlIHRyYW5zcG9ydHMuICBXaGlj
aCBicmluZ3MgbWUgdG8gbXkgbmV4dCBsZXZlbC4uLg0KPiANCj4gT24gYSBwZXIgcXVldWUgcGFp
ciBiYXNpczogaWYgKGxpbmtfbGF5ZXIgPT0gRXRoZXJuZXQpIGlXQVJQL1JvQ0UvVVNOSUMNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChxcF90eXBlID09IFJvQ0UgJiYgcXAgIT0gVUQp
IFJvQ0V2MS9Sb0NFdjINCj4gDQo+IE9uIGEgcGVyIGFoIGJhc2lzOiBpZiAocXBfdHlwZSA9PSBS
b0NFICYmIHFwID0gVUQpIFJvQ0V2MS9Sb0NFdjINCj4gDQo+IE1pY2hhZWwncyBwYXRjaCBzZXQg
d2FzIGludGVuZGVkIHRvIGdpdmUgdXMgYSBmcmFtZXdvcmsgd2l0aGluIHdoaWNoIHdlDQo+IGNh
biBzdGFydCBjbGVhbmluZyB0aGluZ3MgdXAuICBPbmNlIHdlIGdldCB0byBjbGVhbmluZyB0aGlu
Z3MgdXAsIEkNCj4gdGhpbmsgdGhlIGFib3ZlIGlzIHdoZXJlIHdlIHNob3VsZCB0YXJnZXQgc3Rv
cmluZyB0aGUgcmVsZXZhbnQNCj4gaW5mb3JtYXRpb24uDQo+IA0KPiBUaG91Z2h0cz8NCg0KSSdt
IG5vdCBmb2xsb3dpbmcgeW91ciBpbnRlbnQgaGVyZS4NCg0KVGhlIHFwX3R5cGUgdmFsdWVzIGFy
ZSBjdXJyZW50bHkgZGVmaW5lZCBhcyBSQywgVUMsIFVELCBYUkMsIHBsdXMgc29tZSB3ZWlyZG5l
c3MgbGlrZSBTTUksIEdTSS4gIEFyZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IHdlIHN0b3JlIHRoZSBy
ZWxldmFudCBpbmZvcm1hdGlvbiBhcyBwYXJ0IG9mIHRoZSBxcF90eXBlLCBvciB0aGF0IHdlIGtl
ZXAgdGhlIHFwX3R5cGUgYXMtaXM/DQogDQpPbmNlIE1pY2hhZWwncyBwYXRjaGVzIGFyZSBpbnRl
Z3JhdGVkLCBkbyBhcHBzIG5lZWQgYW55dGhpbmcgZWxzZSBiZXlvbmQgdGhlIHFwIHR5cGUgYXMg
Y3VycmVudGx5IGRlZmluZWQ/DQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
