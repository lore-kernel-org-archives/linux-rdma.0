From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] srp_daemon: fix CQ handling
Date: Tue, 12 Dec 2017 17:04:54 +0000
Message-ID: <1513098293.2999.15.camel@wdc.com>
References: <05bbb67fea5e3cae535c0d9d21866cf8ad76f74f.1513087686.git.NMoreyChaisemartin@suse.com>
         <19c1241b-6a22-f8c2-32a2-6233f62cc39c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19c1241b-6a22-f8c2-32a2-6233f62cc39c-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <8DA450C2B872EE4A8150D918BF783D59-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDE1OjA4ICswMTAwLCBOaWNvbGFzIE1vcmV5LUNoYWlzZW1h
cnRpbiB3cm90ZToNCj4gK3N0YXRpYyBpbnQgcG9sbF9jcV9vbmNlKHN0cnVjdCBzeW5jX3Jlc291
cmNlcyAqc3luY19yZXMsIHN0cnVjdCBpYnZfY3EgKmNxLA0KPiArCQkJc3RydWN0IGlidl93YyAq
d2MpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKwlyZXQgPSBpYnZfcG9sbF9jcShjcSwgMSwgd2Mp
Ow0KDQpQbGVhc2UgbGVhdmUgb25lIGJsYW5rIGxpbmUgYmV0d2VlbiBkZWNsYXJhdGlvbnMgYW5k
IHN0YXRlbWVudHMuDQoNCj4gKwlpZiAocmV0IDwgMCkgew0KPiArCQlwcl9lcnIoInBvbGwgQ1Eg
ZmFpbGVkXG4iKTsNCj4gKwkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsNCj4gKwlpZiAocmV0ID4g
MCAmJiB3Yy0+c3RhdHVzICE9IElCVl9XQ19TVUNDRVNTKSB7DQo+ICsJCWlmICghc3RvcF90aHJl
YWRzKHN5bmNfcmVzKSkNCj4gKwkJCXByX2VycigiZ290IGJhZCBjb21wbGV0aW9uIHdpdGggc3Rh
dHVzOiAweCV4XG4iLA0KPiArCQkJICAgICAgIHdjLT5zdGF0dXMpOw0KPiArCQlyZXR1cm4gLXJl
dDsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KDQpUaGlzIGZ1bmN0aW9uIGNh
biByZXR1cm4gbmVnYXRpdmUgdmFsdWVzLCBwb3NpdGl2ZSB2YWx1ZXMgb3IgemVyby4gUGxlYXNl
DQptb2RpZnkgaXQgc3VjaCB0aGF0IGVpdGhlciAwIG9yIGEgbmVnYXRpdmUgVW5peCBlcnJvciBj
b2RlIGlzIHJldHVybmVkLiBUaGlzDQp3aWxsIG1ha2UgaXQgZWFzaWVyIHRvIHJlYWQgdGhpcyBm
dW5jdGlvbiBhbmQgYWxzbyB0aGUgY29kZSB0aGF0IGNhbGxzIHRoaXMNCmZ1bmN0aW9uLg0KDQpU
aGFua3MsDQoNCkJhcnQuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
