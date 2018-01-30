From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 20:42:44 +0000
Message-ID: <1517344962.2589.39.camel@wdc.com>
References: <20180128091725.13103-1-leon@kernel.org>
         <20180128210520.GK23869@ziepe.ca> <1517256713.27592.241.camel@redhat.com>
         <20180130033436.GA17053@ziepe.ca> <20180130091654.GD2055@mtr-leonro.local>
         <034101d399de$01183730$0348a590$@opengridcomputing.com>
         <20180130155643.GC17053@ziepe.ca>
         <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
         <20180130163330.GE17053@ziepe.ca> <1517339252.2589.34.camel@wdc.com>
         <20180130194639.GJ17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130194639.GJ17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <E06710441921FB438C63546F21C62F5E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDEyOjQ2IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgSmFuIDMwLCAyMDE4IGF0IDA3OjA3OjM1UE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMTgtMDEtMzAgYXQgMDk6MzMgLTA3MDAsIEphc29u
IEd1bnRob3JwZSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgSmFuIDMwLCAyMDE4IGF0IDEwOjE2OjAx
QU0gLTA2MDAsIFN0ZXZlIFdpc2Ugd3JvdGU6DQo+ID4gPiANCj4gPiA+ID4gV2hhdCBpcyB0aGlz
IGEgbWVyZ2Ugb2YgZXhhY3RseT8gSSBkb24ndCBzZWUgdGhlIHJlc3RyYWNrIHN0dWZmLCBmb3IN
Cj4gPiA+ID4gaW5zdGFuY2UuDQo+ID4gPiANCj4gPiA+IFllc3RlcmRheSdzIGZvci1uZXh0LiBZ
b3UgY291bGQgbWVyZ2UgaXQgd2l0aCB0aGUgbGF0ZXN0IGZvci1uZXh0Li4NCj4gPiA+IA0KPiA+
ID4gSSB1cGRhdGVkIGl0Lg0KPiA+ID4gDQo+ID4gPiBJIHRoaW5rIHdlIGFyZSBkb25lIG5vdywg
c28gZm9yLW5leHQgaXMgd2hhdCB3aWxsIGJlIHNlbnQgYXMgdGhlDQo+ID4gPiBwdWxsLXJlcXVl
c3QgYW5kIGZvci1uZXh0LW1lcmdlZCBpcyB0aGUgY29uZmxpY3QgcmVzb2x1dGlvbi4NCj4gPiAN
Cj4gPiBIZWxsbyBKYXNvbiwNCj4gPiANCj4gPiBBbHRob3VnaCBJIGhhdmUgbm90IHlldCB0cmll
ZCB0byByb290LWNhdXNlIHRoaXMsIEkgd2FudCB0byBsZXQgeW91IGtub3cNCj4gPiB0aGF0IHdp
dGggeW91ciBmb3ItbGludXMtbWVyZ2VkIGJyYW5jaCB0aGUgZm9sbG93aW5nIGVycm9yIG1lc3Nh
Z2UgaXMNCj4gPiByZXBvcnRlZCBpZiBJIHRyeSB0byBydW4gdGhlIHNycC10ZXN0IHNvZnR3YXJl
IGFnYWluc3QgdGhlIHJkbWFfcnhlIGRyaXZlcjoNCj4gPiANCj4gPiBpZF9leHQ9MHg1MDU0MDBm
ZmZlNGEwYjdiLGlvY19ndWlkPTB4NTA1NDAwZmZmZTRhMGI3YixkZXN0PTE5Mi4xNjguMTIyLjc2
OjU1NTUsdA0KPiA+IGFyZ2V0X2Nhbl9xdWV1ZT0xLHF1ZXVlX3NpemU9MzIsbWF4X2NtZF9wZXJf
bHVuPTMyLG1heF9zZWN0PTEzMTA3MiA+L3N5cy9jbGFzcy9pDQo+ID4gbmZpbmliYW5kX3NycC9z
cnAtcnhlMC0xL2FkZF90YXJnZXQgZmFpbGVkOiBDYW5ub3QgYWxsb2NhdGUgbWVtb3J5DQo+ID4g
DQo+ID4gSW4gdGhlIGtlcm5lbCBsb2cgSSBmb3VuZCB0aGUgZm9sbG93aW5nOg0KPiA+IA0KPiA+
IEphbiAzMCAxMDo1NTo1MCB1YnVudHUtdm0ga2VybmVsOiBzY3NpIGhvc3Q0OiBpYl9zcnA6IEZS
IHBvb2wgYWxsb2NhdGlvbiBmYWlsZWQgKC0xMikNCj4gPiANCj4gPiBXaXRoIHlvdXIgZm9yLW5l
eHQgYnJhbmNoIGZyb20gYSBmZXcgZGF5cyBhZ28gdGhlIHNhbWUgdGVzdCByYW4gZmluZS4NCj4g
DQo+IEkgZG9uJ3QgaGF2ZSBhIGd1ZXNzIGZvciB5b3UuLg0KPiANCj4gVGhlIGRpZmZlcmVuY2Ug
YmV0d2VlbiBmb3ItbmV4dCBhbmQgbWVyZ2VkIGlzIG9ubHkgdGhlIGluY2x1c2lvbiBvZg0KPiB2
NC4xNT8gQ291bGQgc29tZSB2NC4xNSBub24tcmRtYSBjb2RlIGJlIGNhdXNpbmcgaXNzdWUgaGVy
ZT8NCg0KSGVsbG8gSmFzb24sDQoNCkkgc2hvdWxkIGhhdmUgbWVudGlvbmVkIHRoYXQgaW4gdGhl
IHByZXZpb3VzIHRlc3RzIEkgcmFuIEkgbWVyZ2VkIGtlcm5lbA0KdjQuMTUtcmM5IG15c2VsZiBp
bnRvIHRoZSBSRE1BIGZvci1uZXh0IGJyYW5jaC4gU28gdGhpcyBiZWhhdmlvciB3YXMgcHJvYmFi
bHkNCmludHJvZHVjZWQgYnkgYSBwYXRjaCB0aGF0IHdhcyBxdWV1ZWQgcmVjZW50bHkgb24gdGhl
IFJETUEgZm9yLW5leHQgYnJhbmNoLA0KZS5nLiBSRE1BIHJlc291cmNlIHRyYWNraW5nLg0KDQpC
YXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
