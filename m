From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 10/27] IB/Verbs: Reform cm related part in IB-core
 cma/ucm
Date: Thu, 16 Apr 2015 17:30:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC2508@ORSMSX109.amr.corp.intel.com>
References: <552F6CF2.4000606@profitbricks.com>
 <552F6DEA.9080701@profitbricks.com> <552FB4D0.5080302@dev.mellanox.co.il>
 <552FB6EF.80107@profitbricks.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC22C3@ORSMSX109.amr.corp.intel.com>
 <552FD3BE.4090204@profitbricks.com> <552FEFAC.6080402@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FEFAC.6080402-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IFRvIGJlIGNvbmZpcm1lZDoNCj4gPiAJCQkJUE9SVCBBU1NJR05FRA0KPiA+IAlyZG1hX2lu
aXRfcXBfYXR0cglZDQo+ID4gCXJkbWFfZGVzdHJveV9pZAkJdW5rbm93bg0KPiA+IAljbWFfbGlz
dGVuX29uX2RldglODQo+ID4gCWNtYV9iaW5kX2xvb3BiYWNrCU4NCg0KQmluZCBsb29wYmFjayB3
aWxsIGF0dGFjaCB0byBhIHBvcnQsIGJ1dCB0aGUgaWQgZG9lcyBub3QgaGF2ZSBvbiBlbnRyeS4N
Cg0KPiA+IAlyZG1hX2xpc3RlbgkJTg0KPiANCj4gV2h5ICJOIj8gcmRtYV9saXN0ZW4oKSBjYW4g
YmUgY29uc3RyYWluZWQgdG8gYSBzaW5nbGUgcG9ydCwgcmlnaHQ/DQo+IEFuZCBldmVuIGlmIHdp
bGRjYXJkZWQsIGl0IG5lZWRzIHRvIGFjdCBvbiBtdWx0aXBsZSBwb3J0cywgd2hpY2ggaXMNCj4g
dG8gc2F5LCBpdCB3aWxsIGZhaWwgb25seSBpZiBubyBwb3J0cyBhcmUgZWxpZ2libGUuDQoNClJk
bWEgbGlzdGVuIHNob3VsZCBiZSB1bmtub3duLiAgVGhlIGlkIG1heSBiZSBhc3NpZ25lZCB0byBh
IHBvcnQuICBJdCBkZXBlbmRzIG9uIHRoZSBzb3VyY2UgYWRkcmVzcy4NCg0KPiA+IAlyZG1hX2Nv
bm5lY3QJCVkNCj4gPiAJcmRtYV9hY2NlcHQJCVkNCj4gPiAJcmRtYV9yZWplY3QJCVkNCj4gPiAJ
cmRtYV9kaXNjb25uZWN0CQlZDQo+ID4gCWliX3VjbV9hZGRfb25lCQlODQoNCk90aGVycyBsb29r
IGNvcnJlY3QuDQoNCkJ0dywgdGhhbmtzIGZvciB5b3VyIHdvcmsgb24gdGhpcy4gIEkga25vdyB0
aGlzIGlzIGJlY29taW5nIGEgbXVjaCBiaWdnZXIgY2hhbmdlIHRoYW4geW91IG9yaWdpbmFsbHkg
aW50ZW5kZWQuICA6KQ0KDQotIFNlYW4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
