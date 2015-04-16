From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 10/27] IB/Verbs: Reform cm related part in IB-core
 cma/ucm
Date: Thu, 16 Apr 2015 14:31:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC22C3@ORSMSX109.amr.corp.intel.com>
References: <552F6CF2.4000606@profitbricks.com>
 <552F6DEA.9080701@profitbricks.com> <552FB4D0.5080302@dev.mellanox.co.il>
 <552FB6EF.80107@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FB6EF.80107-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IFRoaXMgaXMgZXF1aXZhbGVudCB0byB0b2RheSB3aGVyZSB0aGUgY2hlY2tzIGFyZSBwZXIg
bm9kZSByYXRoZXIgdGhhbg0KPiA+IHBlciBwb3J0Lg0KPiA+DQo+ID4gU2hvdWxkIGFsbCBjaGVj
a3MgaGVyZSBiZSBwb3J0IDEgYmFzZWQgb3Igb25seSBjZXJ0YWluIG9uZXMgbGlrZSBsaXN0ZW4N
Cj4gPiA/IEZvciBleGFtcGxlLCBpbiBjb25uZWN0L3JlamVjdC9kaXNjb25uZWN0LCBkb24ndCB3
ZSBhbHJlYWR5IGhhdmUgcG9ydA0KPiA+ID8gR3Vlc3MgdGhpcyBjYW4gYmUgZGVhbHQgd2l0aCBs
YXRlciBhcyB0aGlzIGlzIG5vdCBhIHJlZ3Jlc3Npb24gZnJvbQ0KPiA+IHRoZSBjdXJyZW50IGlt
cGxlbWVudGF0aW9uLg0KPiANCj4gWWVhaCwgdGhlc2UgcGFydHMgb2YgY21hIG1heSBuZWVkIG1v
cmUgY2FydmUgaW4gZnV0dXJlLCBsaWtlIHNvbWUgbmV3DQo+IGNhbGxiYWNrDQo+IGZvciBkaWZm
ZXJlbnQgQ00gdHlwZSBhcyBTZWFuIHN1Z2dlc3RlZC4NCj4gDQo+IE1heWJlIGRpcmVjdGx5IHVz
aW5nIDEgY291bGQgaGVscCB0byBoaWdobGlnaHQgdGhlIHByb2JsZW0gOy0pDQoNCk9ubHkgYSBm
ZXcgY2hlY2tzIG5lZWQgdG8gYmUgcGVyIGRldmljZS4gIEkgdGhpbmsgSSBwb2ludGVkIHRob3Nl
IG91dCBwcmV2aW91c2x5LiAgVGVzdGluZyBzaG91bGQgc2hvdyBhbnl3aGVyZSB0aGF0IHdlIG1p
c3MgZmFpcmx5IHF1aWNrbHksIHNpbmNlIHBvcnQgd291bGQgc3RpbGwgYmUgMC4gIEZvciB0aGUg
Y2hlY2tzIHRoYXQgY2FuIGJlIHVwZGF0ZWQgdG8gYmUgcGVyIHBvcnQsIEkgd291bGQgcmF0aGVy
IGdvIGFoZWFkIGFuZCBjb252ZXJ0IHRoZW0uDQoNCi0gU2Vhbg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
