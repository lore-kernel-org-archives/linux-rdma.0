From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 22:10:00 +0000
Message-ID: <1517350199.2589.65.camel@wdc.com>
References: <20180130163330.GE17053@ziepe.ca>
         <1517339252.2589.34.camel@wdc.com> <20180130194639.GJ17053@ziepe.ca>
         <1517344962.2589.39.camel@wdc.com> <20180130204840.GK17053@ziepe.ca>
         <1517347322.2589.58.camel@wdc.com> <1517347999.15224.2.camel@redhat.com>
         <1517348412.2589.60.camel@wdc.com> <20180130214227.GM17053@ziepe.ca>
         <1517348867.2589.63.camel@wdc.com> <20180130220233.GN17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130220233.GN17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <653C37C855A8AB4C94464F8AEFABD001-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDE1OjAyIC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgSmFuIDMwLCAyMDE4IGF0IDA5OjQ3OjQ4UE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBTbyBhcHBhcmVudGx5IHRoZSBpYl9hbGxvY19tcigpIGZhaWxzIHNv
bWV0aW1lcyAoYnV0IG5vdCB0aGUgZmlyc3QgZmV3IHRpbWVzDQo+ID4gaXQgaXMgY2FsbGVkKS4N
Cj4gDQo+IExvb2tzIGxpa2UgdGhlIG9ubHkgd2F5IHlvdSBjYW4gZ2V0IHRoYXQgd2l0aG91dCBo
aXR0aW5nIGFuIGthbGxvYw0KPiBvb3BzIHByaW50IGlzIGlmIHJ4ZV9hbGxvYygpIGZhaWxzLCBh
bmQgcHJvYmFibHkgaGVyZToNCj4gDQo+IAlpZiAoYXRvbWljX2luY19yZXR1cm4oJnBvb2wtPm51
bV9lbGVtKSA+IHBvb2wtPm1heF9lbGVtKQ0KPiAJCWdvdG8gb3V0X3B1dF9wb29sOw0KPiANCj4g
U3VnZ2VzdGluZyBzcnAgaGl0IHRoZSBtYXggIyBvZiBtcnMgaW4gcnhlOg0KPiANCj4gCVJYRV9N
QVhfTVIJCQk9IDIgKiAxMDI0LA0KPiANCj4gT3IgbWF5YmUgd2UgYXJlIG5vdyBsZWFraW5nIG1y
cyBzb21lcGxhY2U/DQo+IA0KPiBUaGVyZSBpcyBub3RoaW5nIGFjY2VwdGVkIHJlY2VudGx5IHRo
YXQgbXVja3Mgd2l0aCB0aGlzLCBzdGlsbCBub3QNCj4gc2VlaW5nIGV2ZW4gYSB0ZW51b3VzIGNv
bm5lY3Rpb24gdG8gYW55IHBhdGNoZXMgaW4gdGhlIGxhc3QgZmV3IGRheXMNCg0KSGVsbG8gSmFz
b24sDQoNClNpbmNlIHRoZSBudW1iZXIgb2YgbWVtb3J5IHJlZ2lvbnMgdGhhdCBpcyBhbGxvY2F0
ZWQgYnkgdGhlIGliX3NycCBkcml2ZXINCmRlcGVuZHMgb24gdGhlIG1heF9zZWN0IHBhcmFtZXRl
ciBpbiB0aGUgbG9naW4gc3RyaW5nIEkgd2lsbCBzdGFydCB3aXRoDQpjaGVja2luZyB3aGV0aGVy
IHRoZXJlIGhhdmUgYmVlbiBhbnkgcmVjZW50IGNoYW5nZXMgb2YgdGhhdCBwYXJhbWV0ZXIgaW4N
CnRoZSB0ZXN0IHNjcmlwdC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
