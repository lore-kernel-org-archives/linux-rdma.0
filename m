From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
	multicast response
Date: Mon, 21 Nov 2011 18:00:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9BA3D@ORSMSX101.amr.corp.intel.com>
References: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9D0@ORSMSX101.amr.corp.intel.com>
 <35AAF1E4A771E142979F27B51793A48888478C9BF8@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A48888478C9BF8-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGUgZGVmZXJlbmNlIG9jY3VycyBpbiB0aGUgbm9uLUlTX0VSUigpIHBhdGguICBIZXJlIGlz
IHRoZSBwYXRjaGVkIGNvZGU6DQo+IA0KPiAgICAgICAgIHZhaCA9IGliX2NyZWF0ZV9haChwZCwg
YXR0cik7DQo+ICAgICAgICAgaWYgKElTX0VSUih2YWgpKSB7DQo+ICAgICAgICAgICAgICAgICBr
ZnJlZShhaCk7DQo+ICAgICAgICAgICAgICAgICBhaCA9IChzdHJ1Y3QgaXBvaWJfYWggKil2YWg7
DQo+ICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAgICAgICAgICAgIGFoLT5haCA9IHZhaDsgPC0t
LS0tLS0tLS0tLS0tLS0tLSBkZWZlciB3L28gZnJlZQ0KPiAgICAgICAgICAgICAgICAgaXBvaWJf
ZGJnKG5ldGRldl9wcml2KGRldiksICJDcmVhdGVkIGFoICVwXG4iLCBhaC0+YWgpOw0KPiAgICAg
ICAgIH0NCj4gDQo+IEkgYWdyZWUgdGhhdCBwZXJoYXBzIHRoZSBjb2RlIHNob3VsZCBqdXN0IHJl
dHVybiBhIGNhc3Qgb2YgdmFoIGluIHRoZSBJU19FUlIoKQ0KPiBjYXNlIHNvIGl0J3MgY2xlYXJl
cj8NCg0KVGhhbmtzIGZvciBjbGFyaWZ5aW5nLiAgSSBtaXNyZWFkIHRoZSBwYXRjaC4gIFRoZSBy
ZXN1bHRpbmcgZnVuY3Rpb24gbG9va3MgY2xlYXIgZW5vdWdoIHdpdGggZXZlcnl0aGluZyB0b2dl
dGhlci4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
