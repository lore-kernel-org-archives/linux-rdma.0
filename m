From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] srp_daemon: fix CQ handling
Date: Mon, 11 Dec 2017 16:30:09 +0000
Message-ID: <1513009807.2747.11.camel@wdc.com>
References: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
         <f35bfdad-9027-d2be-9706-b5a0edd9a778@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f35bfdad-9027-d2be-9706-b5a0edd9a778-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <CC0E63CF91E3F747AACAE573F3D1F1C4-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTEyLTExIGF0IDE1OjQ2ICswMTAwLCBOaWNvbGFzIE1vcmV5LUNoYWlzZW1h
cnRpbiB3cm90ZToNCj4gK3RhdGljIGludCBwb2xsX2NxX29uY2Uoc3RydWN0IHN5bmNfcmVzb3Vy
Y2VzICpzeW5jX3Jlcywgc3RydWN0IGlidl9jcSAqY3EsDQo+ICsgICAgICAgICAgIHN0cnVjdCBp
YnZfd2MgKndjKQ0KDQpIYXMgdGhpcyBwYXRjaCBiZWVuIHRlc3RlZD8gSSBkb24ndCB0aGluayB0
aGF0ICJ0YXRpYyIgaXMgYSB2YWxpZCBrZXl3b3JkPw0KDQo+ICsJCS8qIFBvbGwgQ1Egb25jZS4g
VGhlcmUgbWF5IGJlIGV4dHJhIGNvbXBsZXRpb24gdGhhdA0KPiArCQkgKiB3ZXJlIGFzc29jaWF0
ZWQgdG8gdGhlIHByZXZpb3VzIGV2ZW50ICovDQo+ICsJCXJldCA9IHBvbGxfY3Ffb25jZShzeW5j
X3JlcywgY3EsIHdjKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXJldHVybiByZXQ7DQoNCkhvdyBt
YW55IGV4dHJhIGNvbXBsZXRpb25zIGNhbiBiZSBhc3NvY2lhdGVkIHdpdGggYW4gZXZlbnQ/IElz
IHBvbGxpbmcgb25jZQ0Kc3VmZmljaWVudD8gSWYgc28sIHBsZWFzZSB1cGRhdGUgdGhlIGNvbW1l
bnQgKCJhbiIgaXMgbWlzc2luZyAvICJ3ZXJlIiAtPg0KIndhcyIpLg0KDQpUaGFua3MsDQoNCkJh
cnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
