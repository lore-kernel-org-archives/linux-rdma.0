From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ
 to using RC
Date: Fri, 3 Nov 2017 16:01:08 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC6266E41A@fmsmsx120.amr.corp.intel.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
         <20171011172729.16984-5-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC6266931A@fmsmsx120.amr.corp.intel.com>
 <1509658914.2484.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGUgUk5SIG5ha3MgYXJlIGhhcHBlbmluZyBiZWNhdXNlIEFMTCBwb3N0IHJlY2VpdmVzIGZh
aWwgaW4gYSBRUCBzdGF0ZSBvZg0KPiByZXNldC4NCj4gDQoNCk1vdmluZyB0aGUgcG9zdCByZWNl
aXZlcyB0aWxsIGFmdGVyIHRoZSBpbml0IHdvcmtzOg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9p
bmZpbmliYW5kL3VscC9zcnB0L2liX3NycHQuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3Jw
dC9pYl9zcnB0LmMNCmluZGV4IDMwNDg1NWIuLjk4YjFiODAgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L2luZmluaWJhbmQvdWxwL3NycHQvaWJfc3JwdC5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQv
dWxwL3NycHQvaWJfc3JwdC5jDQpAQCAtMTY4NywxMCArMTY4Nyw2IEBAIHN0YXRpYyBpbnQgc3Jw
dF9jcmVhdGVfY2hfaWIoc3RydWN0IHNycHRfcmRtYV9jaCAqY2gpDQogICAgICAgICAgICAgICAg
Z290byBlcnJfZGVzdHJveV9jcTsNCiAgICAgICAgfQ0KDQotICAgICAgIGlmICghc2Rldi0+dXNl
X3NycSkNCi0gICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgY2gtPnJxX3NpemU7IGkrKykN
Ci0gICAgICAgICAgICAgICAgICAgICAgIHNycHRfcG9zdF9yZWN2KHNkZXYsIGNoLCBjaC0+aW9j
dHhfcmVjdl9yaW5nW2ldKTsNCi0NCiAgICAgICAgYXRvbWljX3NldCgmY2gtPnNxX3dyX2F2YWls
LCBxcF9pbml0LT5jYXAubWF4X3NlbmRfd3IpOw0KDQogICAgICAgIHByX2RlYnVnKCIlczogbWF4
X2NxZT0gJWQgbWF4X3NnZT0gJWQgc3Ffc2l6ZSA9ICVkIGNtX2lkPSAlcFxuIiwNCkBAIC0xNzAx
LDYgKzE2OTcsMTAgQEAgc3RhdGljIGludCBzcnB0X2NyZWF0ZV9jaF9pYihzdHJ1Y3Qgc3JwdF9y
ZG1hX2NoICpjaCkNCiAgICAgICAgaWYgKHJldCkNCiAgICAgICAgICAgICAgICBnb3RvIGVycl9k
ZXN0cm95X3FwOw0KDQorICAgICAgIGlmICghc2Rldi0+dXNlX3NycSkNCisgICAgICAgICAgICAg
ICBmb3IgKGkgPSAwOyBpIDwgY2gtPnJxX3NpemU7IGkrKykNCisgICAgICAgICAgICAgICAgICAg
ICAgIHNycHRfcG9zdF9yZWN2KHNkZXYsIGNoLCBjaC0+aW9jdHhfcmVjdl9yaW5nW2ldKTsNCisN
CiBvdXQ6DQogICAgICAgIGtmcmVlKHFwX2luaXQpOw0KICAgICAgICByZXR1cm4gcmV0Ow0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
