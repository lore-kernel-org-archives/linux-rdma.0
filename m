From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Tue, 19 Dec 2017 16:57:35 +0000
Message-ID: <1513702653.2535.3.camel@wdc.com>
References: <20171214110241.4701-1-honli@redhat.com>
         <1513263572.2986.2.camel@wdc.com>
         <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
         <20171215172800.GA12434@ziepe.ca>
         <20171219122050.GA19682@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219122050.GA19682-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Content-Language: en-US
Content-ID: <EC480B659848F54FAF76C0F364CD1805-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTE5IGF0IDIwOjIwICswODAwLCBIb25nZ2FuZyBMSSB3cm90ZToNCj4g
QXMgaWJzcnBkbSBhbHdheXMgb25seSBydW4gb25jZSwgYmVjYXVzZSAiY29uZmlnLT5vbmNlIiBo
YXMgYmVlbg0KPiBhc3NpZ25lZCB0byAxLiBJIHdvdWxkIHN1Z2dlc3QgdG8gYXBwbHkgdGhpcyBw
YXRjaC4NCj4gDQo+IGRpZmYgLS1naXQgYS9zcnBfZGFlbW9uL3NycF9kYWVtb24uYyBiL3NycF9k
YWVtb24vc3JwX2RhZW1vbi5jDQo+IGluZGV4IGNlYzM2ZGIyLi40MDEyYTdkYiAxMDA2NDQNCj4g
LS0tIGEvc3JwX2RhZW1vbi9zcnBfZGFlbW9uLmMNCj4gKysrIGIvc3JwX2RhZW1vbi9zcnBfZGFl
bW9uLmMNCj4gQEAgLTE5NDUsMTIgKzE5NDUsMTIgQEAgc3RhdGljIHN0cnVjdCByZXNvdXJjZXMg
KmFsbG9jX3Jlcyh2b2lkKQ0KPiAgCQkJCSAgICAgcnVuX3RocmVhZF9nZXRfdHJhcF9ub3RpY2Vz
LCAmcmVzLT5yZXMpOw0KPiAgCQlpZiAocmV0KQ0KPiAgCQkJZ290byBlcnI7DQo+IC0JfQ0KPiAg
DQo+IC0JcmV0ID0gcHRocmVhZF9jcmVhdGUoJnJlcy0+cmVzLmFzeW5jX2V2X3RocmVhZCwgTlVM
TCwNCj4gLQkJCSAgICAgcnVuX3RocmVhZF9saXN0ZW5fdG9fZXZlbnRzLCAmcmVzLT5yZXMpOw0K
PiAtCWlmIChyZXQpDQo+IC0JCWdvdG8gZXJyOw0KPiArCQlyZXQgPSBwdGhyZWFkX2NyZWF0ZSgm
cmVzLT5yZXMuYXN5bmNfZXZfdGhyZWFkLCBOVUxMLA0KPiArCQkJCSAgICAgcnVuX3RocmVhZF9s
aXN0ZW5fdG9fZXZlbnRzLCAmcmVzLT5yZXMpOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJZ290byBl
cnI7DQo+ICsJfQ0KPiAgDQo+ICAJaWYgKGNvbmZpZy0+cmV0cnlfdGltZW91dCAmJiAhY29uZmln
LT5vbmNlKSB7DQo+ICAJCXJldCA9IHB0aHJlYWRfY3JlYXRlKCZyZXMtPnJlcy5yZWNvbm5lY3Rf
dGhyZWFkLCBOVUxMLA0KDQpQbGVhc2Ugc3VibWl0IHRoaXMgYXMgYSBwcm9wZXIgcGF0Y2ggYW5k
IGFkZCB0aGUgZm9sbG93aW5nOg0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0
LnZhbmFzc2NoZUB3ZGMuY29tPg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
