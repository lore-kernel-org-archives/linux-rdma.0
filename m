From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 19:07:35 +0000
Message-ID: <1517339252.2589.34.camel@wdc.com>
References: <20180128091725.13103-1-leon@kernel.org>
         <20180128210520.GK23869@ziepe.ca> <1517256713.27592.241.camel@redhat.com>
         <20180130033436.GA17053@ziepe.ca> <20180130091654.GD2055@mtr-leonro.local>
         <034101d399de$01183730$0348a590$@opengridcomputing.com>
         <20180130155643.GC17053@ziepe.ca>
         <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
         <20180130163330.GE17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130163330.GE17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <D5047CEE5E373E49928CD8EAD740C59D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDA5OjMzIC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgSmFuIDMwLCAyMDE4IGF0IDEwOjE2OjAxQU0gLTA2MDAsIFN0ZXZlIFdpc2Ug
d3JvdGU6DQo+IA0KPiA+IFdoYXQgaXMgdGhpcyBhIG1lcmdlIG9mIGV4YWN0bHk/IEkgZG9uJ3Qg
c2VlIHRoZSByZXN0cmFjayBzdHVmZiwgZm9yDQo+ID4gaW5zdGFuY2UuDQo+IA0KPiBZZXN0ZXJk
YXkncyBmb3ItbmV4dC4gWW91IGNvdWxkIG1lcmdlIGl0IHdpdGggdGhlIGxhdGVzdCBmb3ItbmV4
dC4uDQo+IA0KPiBJIHVwZGF0ZWQgaXQuDQo+IA0KPiBJIHRoaW5rIHdlIGFyZSBkb25lIG5vdywg
c28gZm9yLW5leHQgaXMgd2hhdCB3aWxsIGJlIHNlbnQgYXMgdGhlDQo+IHB1bGwtcmVxdWVzdCBh
bmQgZm9yLW5leHQtbWVyZ2VkIGlzIHRoZSBjb25mbGljdCByZXNvbHV0aW9uLg0KDQpIZWxsbyBK
YXNvbiwNCg0KQWx0aG91Z2ggSSBoYXZlIG5vdCB5ZXQgdHJpZWQgdG8gcm9vdC1jYXVzZSB0aGlz
LCBJIHdhbnQgdG8gbGV0IHlvdSBrbm93DQp0aGF0IHdpdGggeW91ciBmb3ItbGludXMtbWVyZ2Vk
IGJyYW5jaCB0aGUgZm9sbG93aW5nIGVycm9yIG1lc3NhZ2UgaXMNCnJlcG9ydGVkIGlmIEkgdHJ5
IHRvIHJ1biB0aGUgc3JwLXRlc3Qgc29mdHdhcmUgYWdhaW5zdCB0aGUgcmRtYV9yeGUgZHJpdmVy
Og0KDQppZF9leHQ9MHg1MDU0MDBmZmZlNGEwYjdiLGlvY19ndWlkPTB4NTA1NDAwZmZmZTRhMGI3
YixkZXN0PTE5Mi4xNjguMTIyLjc2OjU1NTUsdA0KYXJnZXRfY2FuX3F1ZXVlPTEscXVldWVfc2l6
ZT0zMixtYXhfY21kX3Blcl9sdW49MzIsbWF4X3NlY3Q9MTMxMDcyID4vc3lzL2NsYXNzL2kNCm5m
aW5pYmFuZF9zcnAvc3JwLXJ4ZTAtMS9hZGRfdGFyZ2V0IGZhaWxlZDogQ2Fubm90IGFsbG9jYXRl
IG1lbW9yeQ0KDQpJbiB0aGUga2VybmVsIGxvZyBJIGZvdW5kIHRoZSBmb2xsb3dpbmc6DQoNCkph
biAzMCAxMDo1NTo1MCB1YnVudHUtdm0ga2VybmVsOiBzY3NpIGhvc3Q0OiBpYl9zcnA6IEZSIHBv
b2wgYWxsb2NhdGlvbiBmYWlsZWQgKC0xMikNCg0KV2l0aCB5b3VyIGZvci1uZXh0IGJyYW5jaCBm
cm9tIGEgZmV3IGRheXMgYWdvIHRoZSBzYW1lIHRlc3QgcmFuIGZpbmUuDQoNClRoYW5rcywNCg0K
QmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
