From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
	multicast response
Date: Mon, 21 Nov 2011 16:53:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9B9D0@ORSMSX101.amr.corp.intel.com>
References: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121134354.26386.85093.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lwb2liL2lwb2liX2liLmMNCj4gKysrIGIv
ZHJpdmVycy9pbmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYl9pYi5jDQo+IEBAIC01NywyMSArNTcs
MjQgQEAgc3RydWN0IGlwb2liX2FoICppcG9pYl9jcmVhdGVfYWgoc3RydWN0IG5ldF9kZXZpY2Ug
KmRldiwNCj4gIAkJCQkgc3RydWN0IGliX3BkICpwZCwgc3RydWN0IGliX2FoX2F0dHIgKmF0dHIp
DQo+ICB7DQo+ICAJc3RydWN0IGlwb2liX2FoICphaDsNCj4gKwlzdHJ1Y3QgaWJfYWggKnZhaDsN
Cj4gDQo+ICAJYWggPSBrbWFsbG9jKHNpemVvZiAqYWgsIEdGUF9LRVJORUwpOw0KPiAgCWlmICgh
YWgpDQo+IC0JCXJldHVybiBOVUxMOw0KPiArCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCj4g
DQo+ICAJYWgtPmRldiAgICAgICA9IGRldjsNCj4gIAlhaC0+bGFzdF9zZW5kID0gMDsNCj4gIAlr
cmVmX2luaXQoJmFoLT5yZWYpOw0KPiANCj4gLQlhaC0+YWggPSBpYl9jcmVhdGVfYWgocGQsIGF0
dHIpOw0KPiAtCWlmIChJU19FUlIoYWgtPmFoKSkgew0KPiArCXZhaCA9IGliX2NyZWF0ZV9haChw
ZCwgYXR0cik7DQo+ICsJaWYgKElTX0VSUih2YWgpKSB7DQo+ICAJCWtmcmVlKGFoKTsNCj4gLQkJ
YWggPSBOVUxMOw0KPiAtCX0gZWxzZQ0KPiArCQlhaCA9IChzdHJ1Y3QgaXBvaWJfYWggKil2YWg7
DQo+ICsJfSBlbHNlIHsNCj4gKwkJYWgtPmFoID0gdmFoOw0KDQpUaGlzIG5lZWRzIHRvIGJlIGZp
eGVkLiAgYWggaXMgZnJlZWQsIGFzc2lnbiB0byBhbiBlcnJvciBjb2RlLCB0aGVuIGRlcmVmZXJl
bmNlZC4NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
