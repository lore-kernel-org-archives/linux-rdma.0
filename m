From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_destroy_cm_id() versus cm callback race ?
Date: Mon, 30 Apr 2012 18:29:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469FED01@ORSMSX101.amr.corp.intel.com>
References: <4F9AC1F2.5070007@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373469D891F@ORSMSX101.amr.corp.intel.com>
 <4F9BBEEB.40806@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9BBEEB.40806-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yangfanlinux <yangfanlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGF0IG1ha2VzIG1lIHdvbmRlciBob3cgaXQgaXMgcHJldmVudGVkIHRoYXQgdHdvIENNIGNh
bGxiYWNrcyBmb3IgdGhlDQo+IHNhbWUgQ00gSUQgcnVuIGNvbmN1cnJlbnRseSBvbiBkaWZmZXJl
bnQgQ1BVcyA/DQoNClRoZSBjYWxsYmFjayBjb2RlIGVuZHMgdXAgbG9va2luZyBsaWtlIHRoaXM6
DQoNCiAgICAgICAgcmV0ID0gYXRvbWljX2luY19hbmRfdGVzdCgmY21faWRfcHJpdi0+d29ya19j
b3VudCk7DQogICAgICAgIGlmICghcmV0KQ0KICAgICAgICAgICAgICAgIGxpc3RfYWRkX3RhaWwo
JndvcmstPmxpc3QsICZjbV9pZF9wcml2LT53b3JrX2xpc3QpOw0KICAgICAgICBzcGluX3VubG9j
a19pcnEoJmNtX2lkX3ByaXYtPmxvY2spOw0KDQogICAgICAgIGlmIChyZXQpDQogICAgICAgICAg
ICAgICAgY21fcHJvY2Vzc193b3JrKGNtX2lkX3ByaXYsIHdvcmspOw0KDQpPbmx5IDEgdGhyZWFk
IHdpbGwgZW5kIHVwIGludm9raW5nIGNhbGxiYWNrcyB0byB0aGUgdXNlci4gIE90aGVyIGV2ZW50
cyBlbmQgdXAgYmVpbmcgcXVldWVkIG9uIHRoZSB3b3JrX2xpc3QgZm9yIGEgZ2l2ZW4gaWQuDQoN
Ci0gU2Vhbg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
