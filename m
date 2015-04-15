From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 01/28] IB/Verbs: Implement new callback
 query_transport()
Date: Wed, 15 Apr 2015 19:29:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC1C7C@ORSMSX109.amr.corp.intel.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB4FA.5000109@profitbricks.com> <552EAF9D.8050400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552EAF9D.8050400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBsaWJpYnZlcmJzIGFsc28gZXhwb3NlcyB0cmFuc3BvcnQgYXQgdGhlIGRldmljZSBsZXZlbC4g
SXNuJ3QgYSBjaGFuZ2UgdG8NCj4gbWFrZSB0cmFuc3BvcnQgcGVyIHBvcnQgcmF0aGVyIHRoYW4g
cGVyIGRldmljZSBuZWVkZWQgdGhlcmUgYXMgd2VsbCB0bw0KPiBiZSBjb25zaXN0ZW50IHdpdGgg
dGhlc2UgcHJvcG9zZWQga2VybmVsIGNoYW5nZXMgPyBJZiBzbywgd291bGQgdGhlDQo+IGFkZGl0
aW9uYWwgSUJvRSB0cmFuc3BvcnQgYmUgZXhwb3NlZCA/IFdlIGFsc28gbmVlZCB0byB3b3JyeSBh
Ym91dA0KPiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IGZvciBleGlzdGluZyBhcHBsaWNhdGlvbnMu
DQoNCkxpYmlidmVyYnMgcHJvYmFibHkgY2FuJ3QgY2hhbmdlIHdpdGhvdXQgYnVtcGluZyB0aGUg
bWFqb3IgdmVyc2lvbiBudW1iZXIuICBJZiB0aGUga2VybmVsIGF0dHJpYnV0ZSBzdHJ1Y3R1cmVz
IGNoYW5nZSwgdGhpcyBpcyBwcm9iYWJseSBzb21ldGhpbmcgdGhhdCB0aGUgdXNlcl92ZXJicyBt
b2R1bGUgd291bGQgbmVlZCB0byBoYW5kbGUgdG8gYXZvaWQgYnJlYWtpbmcgdGhlIEFCSS4NCg0K
LSBTZWFuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
