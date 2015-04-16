From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Thu, 16 Apr 2015 17:21:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC24E3@ORSMSX109.amr.corp.intel.com>
References: <20150413192701.GA19112@obsidianresearch.com>
 <20150413194602.GA21467@phlsvsds.ph.intel.com>
 <20150413200138.GC19112@obsidianresearch.com>
 <20150414141806.GA7354@phlsvsds.ph.intel.com>
 <20150414172514.GB7682@obsidianresearch.com>
 <20150414174311.GA28111@phlsvsds.ph.intel.com>
 <20150414175904.GB13896@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC127C@ORSMSX109.amr.corp.intel.com>
 <20150414182137.GD7682@obsidianresearch.com>
 <552E1A1A.4090704@profitbricks.com>
 <20150416164418.GC22946@obsidianresearch.com>
 <CAG4TOxPMaRAR_B69J1_SHaHh8YMW2Unx786t2FbrA8g=05BAgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPMaRAR_B69J1_SHaHh8YMW2Unx786t2FbrA8g=05BAgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IE5vIGlkZWEsIGJ1dCBoYXZpbmcgaWJfcmVnaXN0ZXJfZGV2aWNlIGZhaWwgYW5kIHVud2lu
ZCBpZiBhIGNsaWVudA0KPiA+IGZhaWxzIHRvIGF0dGFjaCBtYWtlcyBzZW5zZSB0byBtZS4NCj4g
DQo+IEl0IHNlZW1zIGEgYml0IHVuZnJpZW5kbHkgdG8gZmFpbCBhbiBlbnRpcmUgZGV2aWNlIGlm
IG9uZSBVTFAgaGFzIGENCj4gcHJvYmxlbS4gIExldCdzIHNheSB5b3UgaGF2ZSBhIHN5c3RlbSB3
aG9zZSBtYWluIG5ldHdvcmsgY29ubmVjdGlvbiBpcw0KPiBJUG9JQi4gIFdvdWxkIHlvdSB3YW50
IHRoYXQgY29ubmVjdGlvbiB0byBjb21lIHVwIGV2ZW4gaWYsIHNheSwgdGhlDQo+IE5GUy9SRE1B
IHNlcnZlciBmYWlscyB0byBmaW5kIHRoZSBtZW1vcnkgcmVnaXN0cmF0aW9uIHR5cGUgaXQgbGlr
ZXM/DQoNCldoYXQncyBtaXNzaW5nIGlzIHNvbWUgd2F5IGZvciB0aGUgZGV2aWNlIHRvIGluZGlj
YXRlIHdoaWNoIG1vZHVsZXMgYXJlIGFjdHVhbGx5IG5lY2Vzc2FyeSBmb3IgaXQgdG8gcnVuLiAg
V2l0aG91dCBoYXZpbmcgc29tZXRoaW5nIGxpa2UgdGhhdCwgSSBhZ3JlZSB3aXRoIFJvbGFuZC4N
Cg0KLSBTZWFuIA0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
