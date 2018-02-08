From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rfc 3/5] irq_poll: wire up irq_am
Date: Thu, 8 Feb 2018 01:28:25 +0000
Message-ID: <1518053304.2870.95.camel@wdc.com>
References: <20180205220316.30236-1-sagi@grimberg.me>
         <20180205220316.30236-4-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-4-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <8AA0E1CA6C437746A98355703A0E1533-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAyLTA2IGF0IDAwOjAzICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiArdm9pZCBpcnFfcG9sbF9pbml0X2FtKHN0cnVjdCBpcnFfcG9sbCAqaW9wLCB1bnNpZ25lZCBp
bnQgbnJfZXZlbnRzLA0KPiArICAgICAgICB1bnNpZ25lZCBzaG9ydCBucl9sZXZlbHMsIHVuc2ln
bmVkIHNob3J0IHN0YXJ0X2xldmVsLCBpcnFfcG9sbF9hbV9mbiAqYW1mbikNCj4gK3sNCj4gKwlp
b3AtPmFtZm4gPSBhbWZuOw0KPiArCWlycV9hbV9pbml0KCZpb3AtPmFtLCBucl9ldmVudHMsIG5y
X2xldmVscywgc3RhcnRfbGV2ZWwsIGlycV9wb2xsX2FtKTsNCj4gK30NCg0KVGhpcyBmdW5jdGlv
biBoYXMgYSBsYXJnZSBudW1iZXIgb2YgcGFyYW1ldGVycyBhbmQgbW9zdCBvZiB0aGVtIGFyZSBw
YXNzZWQgdmVyYmF0aW0gdG8NCmlycV9hbV9pbml0KCkuIFBsZWFzZSBjb25zaWRlciB0byBpbnRy
b2R1Y2UgYSBzdHJ1Y3R1cmUgZm9yIHRoZXNlIHBhcmFtZXRlcnMgc3VjaCB0aGF0DQp0aGUgbnVt
YmVyIG9mIGZ1bmN0aW9uIGFyZ3VtZW50cyBzdGF5cyByZWFzb25hYmxlLg0KDQpUaGFua3MsDQoN
CkJhcnQuDQoNCg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
