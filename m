From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 21:47:48 +0000
Message-ID: <1517348867.2589.63.camel@wdc.com>
References: <20180130155643.GC17053@ziepe.ca>
         <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
         <20180130163330.GE17053@ziepe.ca> <1517339252.2589.34.camel@wdc.com>
         <20180130194639.GJ17053@ziepe.ca> <1517344962.2589.39.camel@wdc.com>
         <20180130204840.GK17053@ziepe.ca> <1517347322.2589.58.camel@wdc.com>
         <1517347999.15224.2.camel@redhat.com> <1517348412.2589.60.camel@wdc.com>
         <20180130214227.GM17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130214227.GM17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <EC2E243CAFC00A41AB2421CF398F12E2-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDE0OjQyIC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgSmFuIDMwLCAyMDE4IGF0IDA5OjQwOjE0UE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMTgtMDEtMzAgYXQgMTY6MzMgLTA1MDAsIExhdXJl
bmNlIE9iZXJtYW4gd3JvdGU6DQo+ID4gPiBDYW4gSSB0YWtlIHlvdXIgdHJlZSBhbmQgc2VlIGlm
IHRoaXMgZmFpbHMgZm9yIG1lIHRvbywNCj4gPiA+IFlvdXIgbGFzdCB0cmVlIHdhcyBmaW5lLCBz
byBkaWQgbm90IGhhdmUgdGhpcyBsYXRlc3Qgc3R1ZmYuDQo+ID4gPiBDYW4gSSBqdXN0IHB1bGwg
dG8gd2hhdCBJIGhhdmUNCj4gPiANCj4gPiBIZWxsbyBMYXVyZW5jZSwNCj4gPiANCj4gPiBTbyBm
YXIgSSBoYXZlIHNlZW4gdGhpcyBiZWhhdmlvciBvbmx5IGluc2lkZSBhIFZNIGJ1dCBub3QgeWV0
IG9uIGEgc3lzdGVtDQo+ID4gd2l0aCBtb3JlIG1lbW9yeSB0aGFuIHRoZSBWTS4gVGhpcyBpc3N1
ZSBtYXkgYmUgc3BlY2lmaWMgdG8gdGhlIG1lbW9yeSBzaXplDQo+ID4gb2YgdGhlIFZNLiBJIHRo
aW5rIHdlIHNob3VsZCB0cnkgdG8gaXNvbGF0ZSBmdXJodGVyIHdoYXQgY2F1c2VkIHRoaXMgYmVm
b3JlDQo+ID4gdHJ5aW5nIHRvIHJlcHJvZHVjZSBpdCBvbiBtb3JlIHNldHVwcy4NCj4gDQo+IERp
ZCB5b3UgZ2V0IGFuIG9vcHMgcHJpbnQgcmVsYXRlZCBhIGthbGxvYyBmYWlsdXJlPw0KPiANCj4g
T3IgYW0gSSB3cm9uZyBhbmQgdGhlIEVOT01FTSBpcyBjb21pbmcgZnJvbSBzb21lcGxhY2UgZWxz
ZT8NCg0KSGVsbG8gSmFzb24sDQoNCkkganVzdCBub3RpY2VkIHRoZSBmb2xsb3dpbmcgaW4gdGhl
IHN5c3RlbSBsb2c6DQoNCkphbiAzMCAxMjo1MzoxNSB1YnVudHUtdm0ga2VybmVsOiBpYl9zcnA6
IHJ4ZTA6IGliX2FsbG9jX21yKCkgZmFpbGVkLiBUcnkgdG8gcmVkdWNlIG1heF9jbWRfcGVyX2x1
biwgbWF4X3NlY3Qgb3IgY2hfY291bnQNCg0KU28gYXBwYXJlbnRseSB0aGUgaWJfYWxsb2NfbXIo
KSBmYWlscyBzb21ldGltZXMgKGJ1dCBub3QgdGhlIGZpcnN0IGZldyB0aW1lcw0KaXQgaXMgY2Fs
bGVkKS4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
