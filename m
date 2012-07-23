From: "Vepa, Ramkrishna" <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/5] IB/qib: Added congestion control agent
 implementation
Date: Mon, 23 Jul 2012 20:37:02 +0000
Message-ID: <CA14A0F6203653428C6DF96C8D090CF60E47D06F@FMSMSX108.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
 <20120719130403.4706.24376.stgit@kop-dev-sles11-04.qlogic.org>
 <500B9320.7080803@mellanox.com> <500D80BB.4090303@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <500D80BB.4090303-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBDYW4geW91IGVsYWJvcmF0ZSBhIGxpdHRsZSBvbiB0aGUgcm9sZS91c2FnZSBvZiB0aGUgc3lz
ZnMgZW50cmllcyB0aGlzIA0KPiBwYXRjaCBhZGRzPyBJIHdhc24ndCBzdXJlIHRvIGZvbGxvdywg
YmFzaWNhbGx5LCBJIHRob3VnaHQgSUJUQSBDQ0EgDQo+IGRlZmluZWQgdGhpbmcgc3VjaCB0aGF0
IG9uZSBjYW4gc2V0L2dldCBhbnl0aGluZyBDQyByZWxhdGVkICB0aHJvdWdoIA0KPiBNQURzLCBp
c24ndCB0aGF0Pw0KVGhlIFBTTSBsaWJyYXJ5IGN1cnJlbnRseSBpbXBsZW1lbnRzIGEgc3RhdGlj
IGNvbmZpZ3VyYXRpb24gZm9yIGNvbmdlc3Rpb24gDQpjb250cm9sLiBUaGUgcHVycG9zZSBvZiB0
aGlzIHBhdGNoIGlzIHRvIGR5bmFtaWNhbGx5IGNvbnRyb2wgdGhlIENDIGNvbmZpZ3VyYXRpb24N
CmFjcm9zcyB0aGUgZmFicmljIHdpdGggdGhlIE1BRHMgc2VudCBmcm9tIHRoZSBGTS4gVGhlIGNv
bmZpZ3VyYXRpb24gZnJvbQ0KdGhlIENDIHJlbGF0ZWQgTUFEIHNldHMgYXJlIHNlbnQgdXAgdG8g
dGhlIFBTTSBsaWJyYXJ5IHZpYSBzeXNmcyByZWFkcy4gDQoNCj4gQWxzbywgaXQgc2VlbXMgdGhh
dCBsb3RzIChpZiBub3QgbW9zdCBvciBhbGwpIHRoZSBDQyBNQURzIHJlbGF0ZWQgY29kZSAgDQo+
IGlzIGdlbmVyYWwgYW5kIGNhbiAoc2hvdWxkKSBlYXNpbHkgYmUgbW92ZWQgdG8gYmUgdW5kZXIg
dGhlIElCIGNvcmUgDQo+IGhlYWRlcnMgYW5kIHNvdXJjZXMsIGFncmVlPyBXZSBjYW4gZG8gdGhh
dCBhcyBsaXR0bGUgY2xlYW51cCBsYXRlciwgDQo+IGFmdGVyIHRoZSBiaWdnZXIgcGljdHVyZSBp
cyByZWFsaXplZCBoZXJlLg0KWWVzLCBhZ3JlZWQsIHRoZSBDQyBhZ2VudCBjb2RlIGlzIHByZXR0
eSBtdWNoIGdlbmVyYWwgYW5kIGNhbiBiZSBtb3ZlZCBpbnRvIA0KdGhlIElCIGNvcmUuIA0KDQpU
aGFua3MsDQpSYW0NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
