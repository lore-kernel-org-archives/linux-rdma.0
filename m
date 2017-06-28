From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/iser: Handle lack of memory management extentions
 correctly
Date: Wed, 28 Jun 2017 17:46:49 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC34327953@fmsmsx120.amr.corp.intel.com>
References: <20170622190110.27788.19910.stgit@phlsvslse11.ph.intel.com>
 <55a85363-da66-f6d6-f5cc-08b20f148f36@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55a85363-da66-f6d6-f5cc-08b20f148f36-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBIaSBNaWtlLCBmb3IgdGhlIHBhdGNoIGl0c2VsZiwgaXQgYWRkcmVzc2VzIGEgYnVnIHNvLA0K
PiANCj4gQWNrZWQtYnk6IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo+IA0KPiBC
dXQsDQo+IA0KPiBBcyBmb3Igbm90IGhhdmluZyBhbnkgbWF4IHBhZ2VzIGZvciBGTVIgaXQncyBy
ZWFsbHkgYW5ub3lpbmcuDQo+IA0KPiBXaGF0IGRvIHlvdSB0aGluayBhYm91dCBleHBvc2luZyBt
YXhfZmFzdF9yZWdfcGFnZV9saXN0X2xlbiB0bw0KPiBsaW1pdCBhbHNvIGZvciBGTVJzPyBXZSBj
YW4gYWxzbyByZW5hbWUgaXQgdG8gbWF4X3JlZ19wYWdlX2xpc3RfbGVuDQo+IHRvIGdldCByaWQg
b2YgdGhlIEZSV1IgYXNzb2NpYXRpb24uDQo+IA0KPiBUaG91Z2h0cz8NCg0KSSBoYXZlIG5vIGlz
c3VlIHdpdGggeW91ciBwcm9wb3NhbCwgYnV0IEkgd291bGQgcmF0aGVyIGdldCB0aGlzIGZpeGVk
IGFuZCBhZGp1c3QgdGhlIEFQSSB3aXRoIGFuIGFkZGl0aW9uYWwgZml4LiAgIEkgc3VzcGVjdCB3
ZSBwcm9iYWJseSB3YW50IHRvIG1hcmsgdGhpcyBmaXggc3RhYmxlLg0KDQpJIGRpZCBhdWRpdCB0
aGUga2VybmVsIFVMUHMgZm9yIEZNUiB2cy4gRlJNUiB1c2FnZSBhbmQgdGhlIG9ubHkgb25lIHRo
YXQgbG9va2VkIGF0IG1heF9mYXN0X3JlZ19wYWdlX2xpc3RfbGVuIHVuY29uZGl0aW9uYWxseSB3
YXMgaXNlci4NCg0KVGhvbWFzLCBjYW4geW91IHZlcmlmeSB0aGlzIHBhdGNoIGFuZCByZXBseSB3
aXRoIGEgVGVzdGVkLWJ5Og0KDQpNZWFud2hpbGUsIEkgd2lsbCBhdWRpdCBrZXJuZWwgcHJvdmlk
ZXJzIGZvciB3aGljaCBvbmVzIGJlc2lkZXMgcWliIGRvIG5vdCBzdXBwb3J0IHRoZSBleHRlbnNp
b25zIGFuZCBGTVIuDQoNCk1pa2UNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
