From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
	multicast response
Date: Mon, 21 Nov 2011 10:02:35 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A48888478C9BFF@AVEXMB1.qlogic.org>
References: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9D0@ORSMSX101.amr.corp.intel.com>
 <35AAF1E4A771E142979F27B51793A48888478C9BF8@AVEXMB1.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A8237316E9BA3D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9BA3D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGFua3MgZm9yIGNsYXJpZnlpbmcuICBJIG1pc3JlYWQgdGhlIHBhdGNoLiAgVGhlIHJlc3Vs
dGluZyBmdW5jdGlvbg0KPiBsb29rcyBjbGVhciBlbm91Z2ggd2l0aCBldmVyeXRoaW5nIHRvZ2V0
aGVyLg0KDQpUaGFua3MhDQoNCkknbSBhbHNvIGludGVyZXN0ZWQgaW4gY29tbWVudHMgdGhlICJi
dWciIGluIHRoZSBjYWxsZXIsIGlmIHlvdSBoYXZlIGxvb2tlZCB0aGVyZS4uLg0KDQpNaWtlDQoN
ClRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaGVkIGRvY3VtZW50cyBjb250YWluIGluZm9ybWF0
aW9uIGZyb20gUUxvZ2ljIENvcnBvcmF0aW9uIG9yIGl0cyB3aG9sbHktb3duZWQgc3Vic2lkaWFy
aWVzIHRoYXQgbWF5IGJlIGNvbmZpZGVudGlhbC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVk
IHJlY2lwaWVudCwgeW91IG1heSBub3QgcmVhZCwgY29weSwgZGlzdHJpYnV0ZSwgb3IgdXNlIHRo
aXMgaW5mb3JtYXRpb24uIElmIHlvdSBoYXZlIHJlY2VpdmVkIHRoaXMgdHJhbnNtaXNzaW9uIGlu
IGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYnkgcmVwbHkgZS1t
YWlsIGFuZCB0aGVuIGRlbGV0ZSB0aGlzIG1lc3NhZ2UuDQo=

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
