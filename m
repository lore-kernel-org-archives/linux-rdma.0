From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/15] IB/srpt: Simplify srpt_handle_tsk_mgmt()
Date: Tue, 26 Jan 2016 18:35:25 +0000
Message-ID: <F3529576D8E232409F431C309E29399328F6B0C3@CRSMSX102.amr.corp.intel.com>
References: <568BD0FC.70207@sandisk.com> <568BD1D2.1030609@sandisk.com>
 <F3529576D8E232409F431C309E29399328F6B06A@CRSMSX102.amr.corp.intel.com>
 <56A7ADA3.5080507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A7ADA3.5080507-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiANCj4gVGhhbmsgeW91IGZvciB0aGUgZmVlZGJhY2suIFNpbmNlIHRoZSBrZXJuZWwgNC41IG1l
cmdlIGhhcyBiZWVuIGNsb3NlZCBJDQo+IHdpbGwgcmV0ZXN0IGFuZCByZXNlbmQgdGhlIHdob2xl
IHBhdGNoIHNlcmllcy4gDQoNCkJhcnQsDQoNCkluIHRoaXMgY2FzZSBJIHdvdWxkIHN1Z2dlc3Qg
dG8gZXh0ZW5kIHRoZSBwYXRjaCBieSByZW1vdmluZw0KdGhpcyB1bmxpa2VseSBjaGVjaywgc2lu
Y2UgaXQgaXMgYWxzbyB0YWtlbiBjYXJlIG9mIGluIHRhcmdldDoNCg0KQEAgLTE4NDMsMjUgKzE4
MDEsMTAgQEAgc3RhdGljIHZvaWQgc3JwdF9oYW5kbGVfdHNrX21nbXQoc3RydWN0IHNycHRfcmRt
YV9jaCAqY2gsDQogICAgICAgIHNycHRfc2V0X2NtZF9zdGF0ZShzZW5kX2lvY3R4LCBTUlBUX1NU
QVRFX01HTVQpOw0KICAgICAgICBzZW5kX2lvY3R4LT50YWcgPSBzcnBfdHNrLT50YWc7DQogICAg
ICAgIHRjbV90bXIgPSBzcnBfdG1yX3RvX3RjbShzcnBfdHNrLT50c2tfbWdtdF9mdW5jKTsNCi0g
ICAgICAgaWYgKHRjbV90bXIgPCAwKSB7DQotICAgICAgICAgICAgICAgc2VuZF9pb2N0eC0+Y21k
LnNlX3Rtcl9yZXEtPnJlc3BvbnNlID0NCi0gICAgICAgICAgICAgICAgICAgICAgIFRNUl9UQVNL
X01HTVRfRlVOQ1RJT05fTk9UX1NVUFBPUlRFRDsNCi0gICAgICAgICAgICAgICBnb3RvIGZhaWw7
DQotICAgICAgIH0NCg0KVGhhbmtzLA0KQWxleC4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
