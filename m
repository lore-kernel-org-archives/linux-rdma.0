From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 13/47] RDMA/cxgb4: Declare a local variable 'static'
Date: Mon, 9 Oct 2017 23:20:20 +0000
Message-ID: <1507591219.2674.58.camel@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
         <20171006213333.6721-14-bart.vanassche@wdc.com>
         <01ba01d33eef$d3ed5a90$7bc80fb0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01ba01d33eef$d3ed5a90$7bc80fb0$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <E39F5511516637408624D8416AE74189-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE3LTEwLTA2IGF0IDE3OjA5IC0wNTAwLCBTdGV2ZSBXaXNlIHdyb3RlOg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2Rj
LmNvbT4NCj4gPiBDYzogU3RldmUgV2lzZSA8c3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29tPg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvY3hnYjQvY20uYyB8IDIgKy0NCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9jeGdiNC9jbS5jDQo+IA0KPiBi
L2RyaXZlcnMvaW5maW5pYmFuZC9ody9jeGdiNC9jbS5jDQo+ID4gaW5kZXggMjMzMWU3ZDU3NzA0
Li40OWQ5ZjliODcwZTUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2N4
Z2I0L2NtLmMNCj4gPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvY3hnYjQvY20uYw0KPiA+
IEBAIC05OSw3ICs5OSw3IEBAIG1vZHVsZV9wYXJhbShlbmFibGVfdGNwX3dpbmRvd19zY2FsaW5n
LCBpbnQsIDA2NDQpOw0KPiA+ICBNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV90Y3Bfd2luZG93X3Nj
YWxpbmcsDQo+ID4gIAkJICJFbmFibGUgdGNwIHdpbmRvdyBzY2FsaW5nIChkZWZhdWx0PTEpIik7
DQo+ID4gDQo+ID4gLWludCBjNGl3X2RlYnVnOw0KPiA+ICtzdGF0aWMgaW50IGM0aXdfZGVidWc7
DQo+ID4gIG1vZHVsZV9wYXJhbShjNGl3X2RlYnVnLCBpbnQsIDA2NDQpOw0KPiA+ICBNT0RVTEVf
UEFSTV9ERVNDKGM0aXdfZGVidWcsICJvYnNvbGV0ZSIpOw0KPiANCj4gQ2FuIHdlIGp1c3QgcmVt
b3ZlIHRoaXMgbm93PyAgSUUgaGFzIGl0IGJlZW4gMSByZWxlYXNlIHNpbmNlIGl0IHdhcyBvYnNv
bGV0ZWQ/DQoNClRoYXQncyBhIGdvb2QgcXVlc3Rpb24gYnV0IEknbSBub3Qgc3VyZSB3aGF0IHdv
dWxkIGJlIGEgZ29vZCB0aW1lIHRvIHJlbW92ZQ0KdGhpcy4gSSB0aGluayB0aGUgYW5zd2VyIGRl
cGVuZHMgb24gaG93IGxpa2VseSBpdCBpcyB0aGF0IHBlb3BsZSB1c2UgdGhpcw0KdmFyaWFibGUg
aW4gc2NyaXB0cyBvciAvZXRjL21vZHByb2JlLmQgY29uZmlndXJhdGlvbiBmaWxlcyBiZWNhdXNl
IGluIHRoYXQNCmNhc2UgcmVtb3ZpbmcgdGhlIG1vZHVsZSBwYXJhbWV0ZXIgd291bGQgYnJlYWsg
c2V0dXBzLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
