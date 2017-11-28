From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 18:50:44 +0000
Message-ID: <1511895042.28512.6.camel@wdc.com>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
         <20171127183637.GA13966@ziepe.ca> <20171128061517.GO29104@mtr-leonro.local>
         <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
         <20171128183910.GA21325@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171128183910.GA21325-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <859092F993604B4EAEFA8305F9940AA5-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "xavier_huwei-9Onoh4P/yGk@public.gmane.org" <xavier_huwei-9Onoh4P/yGk@public.gmane.org>, "linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "xavier.huwei-WVlzvzqoTvw@public.gmane.org" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTI4IGF0IDExOjM5IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgTm92IDI4LCAyMDE3IGF0IDA4OjIwOjA5QU0gLTA1MDAsIERlbm5pcyBEYWxl
c3NhbmRybyB3cm90ZToNCj4gPiBJIGNvdWxkIHJlc3VibWl0IGp1c3QgdGhlIHNlcmllcywgb3Ig
eW91IGNvdWxkIGp1c3QgcGljayB0aGUgNCBkcml2ZXINCj4gPiBwYXRjaGVzIGZyb20gcGF0Y2h3
b3JrcyB3aGF0ZXZlciBpcyBlYXNpZXN0Lg0KPiANCj4gSSBtYXJrZWQgdGhlbSBpbiBwYXRjaHdv
cmtzLCBidXQgY2FuIHlvdSByZXZpZXcgdGhlIGNvbW1pdCBtZXNzYWdlcw0KPiBhbmQgbWFrZSBz
dXJlIHlvdSB0aGluayBMaW51cyB3aWxsIHNlZSB0aGVtIGFzIHJjIG1hdGVyaWFsIHRvbz8NCg0K
TXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZSByYyBzdGFnZSBpcyBpbnRlbmRlZCBwcmltYXJp
bHkgZm9yIGZpeGVzIGZvcg0KYnVncyBpbnRyb2R1Y2VkIGR1cmluZyB0aGUgbWVyZ2Ugd2luZG93
LiBGb3IgYWxsIHBhdGNoZXMgdGhhdCBkbyBub3QgZml4DQpidWdzIGludHJvZHVjZWQgZHVyaW5n
IHRoZSBtZXJnZSB3aW5kb3cgaXQgc2hvdWxkIGJlIGV2YWx1YXRlZCBjYXJlZnVsbHkNCndoZXRo
ZXIgb3Igbm90IHRoZXNlIGFyZSBpbXBvcnRhbnQgZW5vdWdoIHRvIGJlIGluY2x1ZGVkIGluIGEg
cmMgcHVsbCByZXF1ZXN0Lg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
