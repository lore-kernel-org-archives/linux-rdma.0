From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 6/7] IB/qib: memcpy optimizations
Date: Wed, 9 Nov 2011 16:48:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8DE76@ORSMSX101.amr.corp.intel.com>
References: <20111109163755.29859.42915.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111109163755.29859.42915.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGlzIGZpeCBhZGRzIGFuIHg4Nl82NCBzcGVjaWZpYyByb3V0aW5lIHRoYXQgMSkgcHJvYmVz
IGZvcg0KPiBYODZfRkVBVFVSRV9SRVBfR09PRA0KPiBhbmQgMikgdXNlcyBhbiBpbmxpbmUgYXNt
IHJvdXRpbmUgYnVpbHRvbiByZXAgbW92c3EgdGhhdCB0ZXN0aW5nIGhhcyBzaG93biBpcw0KPiBi
ZXR0ZXIgdGhhbiB0aGUgYnVpbHRpbiBtZW1jcHkgZm9yIGFsbCBjYXNlcyB1cCB0byA0Sy4gIFRo
ZSBwcm9iaW5nIHJvdXRpbmUgaXMNCj4gbm93IGNhbGxlZCB3aGVuIHRoZSBxaWIgbW9kdWxlIGlz
IGxvYWRlZCB0byBlbmFibGUgdGhlIG9wdGltaXphdGlvbi4gICBXaGVuDQo+IFg4Nl9GRUFUVVJF
X1JFUF9HT09EIGlzIG5vdCBzZXQsIHRoZSByb3V0aW5lIHVzZXMgdGhlIGtlcm5lbCdzIHVucm9s
bGVkDQo+IF9fbWVtY3B5DQo+IHdoZW4gdGhlIGxlbmd0aCBpcyBtb3JlIHRoYW4gNjQgYW5kIHRo
ZSBidWlsdGluIG1lbWNweSBvdGhlcndpc2UuDQoNCkhhdmluZyBldmVyeSBkcml2ZXIgaW1wbGVt
ZW50IHRoZWlyIG93biB2ZXJzaW9uIG9mIG1lbWNweSBpcyBhIGJhZCBpZGVhLg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
