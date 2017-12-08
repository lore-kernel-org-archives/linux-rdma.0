From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [RFC rdma-core] srp_daemon: handle SM lid change
Date: Fri, 8 Dec 2017 16:41:06 +0000
Message-ID: <1512751264.26126.1.camel@wdc.com>
References: <1978d0ad-909f-ed8b-5b54-e8c465d3641f@dev.mellanox.co.il>
         <82bd1d9a-7e6a-324e-1e00-43fcf130faf0@suse.com>
         <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
         <dce98958-a6e2-b289-2a58-609d1914affb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dce98958-a6e2-b289-2a58-609d1914affb-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <AFBE917AE0B4E94283970E5C749EB2E6-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE3LTEyLTA4IGF0IDA4OjU2IC0wNTAwLCBEZW5uaXMgRGFsZXNzYW5kcm8gd3Jv
dGU6DQo+IE9uIDEyLzgvMjAxNyA4OjMzIEFNLCBIYWwgUm9zZW5zdG9jayB3cm90ZToNCj4gPiA+
ICAgaW50IGNyZWF0ZV9haChzdHJ1Y3QgdWRfcmVzb3VyY2VzICp1ZF9yZXMpDQo+ID4gPiBAQCAt
NjQxLDcgKzY0OSw3IEBAIHN0YXRpYyBpbnQgcmVnaXN0ZXJfdG9fdHJhcChzdHJ1Y3Qgc3luY19y
ZXNvdXJjZXMgKnN5bmNfcmVzLA0KPiA+ID4gICAJCQlwdGhyZWFkX211dGV4X3VubG9jayhyZXMt
Pm1hZF9idWZmZXJfbXV0ZXgpOw0KPiA+ID4gICAJCX0gd2hpbGUgKHJjID09IDIpOyAvLyB3aGls
ZSBvbGQgcmVzcG9uc2UuDQo+ID4gPiAgIA0KPiA+ID4gLQl9IHdoaWxlIChyYyA9PSAwICYmICsr
Y291bnRlciA8IDMpOw0KPiA+ID4gKwl9IHdoaWxlIChyYyA9PSAwICYmICsrY291bnRlciA8IDUp
Ow0KPiA+ID4gICANCj4gPiA+ICAgCWlmIChjb3VudGVyPT0zKSB7DQo+ID4gDQo+ID4gVGhpcyBz
aG91bGQgYmUgY2hhbmdlZCBmcm9tIDMgdG8gNSBhbHNvLiBDaGFuZ2UgYm90aCB0byBzb21lIGRl
ZmluZSA/DQo+IA0KPiBZZXMgcGxlYXNlIGNoYW5nZSB0aGVzZSB0byBhICNkZWZpbmUgd2l0aCBh
IHNvbWUgd2hhdCBkZXNjcmlwdGl2ZSBuYW1lLiANCj4gVGhhdCB3b3VsZCBtYWtlIHRoZSBjb2Rl
IG11Y2ggYmV0dGVyIHRvIHJlYWQuDQoNCkl0IHdvdWxkIGJlIGV2ZW4gYmV0dGVyIHRvIGNoYW5n
ZSB0aGUgbG9vcCBzdWNoIHRoYXQgaXQgY291bnRzIGRvd24gaW5zdGVhZA0Kb2YgdXAuIFRoZW4g
dGhlIGlmLXN0YXRlbWVudCBhZnRlciB0aGUgbG9vcCBjYW4gdGVzdCB3aGV0aGVyIHRoZSBjb3Vu
dGVyIGhhcw0KcmVhY2hlZCB6ZXJvIGFuZCB0aGUgY29uc3RhbnQgdGhhdCByZXByZXNlbnRzIHRo
ZSBudW1iZXIgb2YgaXRlcmF0aW9ucyB3aWxsDQpvbmx5IG9jY3VyIG9uY2UuDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
