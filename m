From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Tue, 28 Apr 2015 06:14:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC819C@ORSMSX109.amr.corp.intel.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
		 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
		 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
		 <553DE799.5050608@profitbricks.com>
		 <20150427215229.GD5347@phlsvsds.ph.intel.com>
	 <553ED159.2090006@talpey.com> <1430181360.44548.35.camel@redhat.com>
	 <553EDA01.9040708@talpey.com> <1430184275.44548.44.camel@redhat.com>
 <553EE718.1030502@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <553EE718.1030502-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IEtlZXAgaW4gbWluZCB0aGF0IHRoaXMgZW51bSB3YXMgTGlyYW4ncyByZXNwb25zZSB0byBN
aWNoYWVsJ3Mgb3JpZ2luYWwNCj4gPiBwYXRjaC4gIEluIHRoZSBlbnVtIGluIE1pY2hhZWwncyBw
YXRjaCwgdGhlcmUgd2FzIGJvdGggVVNOSUMgYW5kDQo+ID4gVVNOSUNfVURQLg0KPiANCj4gUmln
aHQhIFRoYXQncyB3aHkgSSdtIGNvbmZ1c2VkLiBTZWVtcyB3cm9uZyB0byBkcm9wIGl0LCByaWdo
dD8NCg0KSSB0aGluayB0aGUgb3JpZ2luYWwgVVNOSUMgcHJvdG9jb2wgaXMgbGF5ZXJlZCBkaXJl
Y3RseSBvdmVyIEV0aGVybmV0LiAgVGhlIHByb3RvY29sIGJhc2ljYWxseSBzdG9sZSBhbiBFdGhl
cnR5cGUgKHRoZSBvbmUgdXNlZCBmb3IgSUJvRS9Sb0NFKSBhbmQgaW1wbGVtZW50ZWQgYSBwcm9w
cmlldGFyeSBwcm90b2NvbCBpbnN0ZWFkLiAgSSBoYXZlIG5vIGlkZWEgaG93IHlvdSByZXNvbHZl
IHRoYXQsIGJ1dCBJIGFsc28gZG9uJ3QgdGhpbmsgaXQncyB1c2VkIGFueW1vcmUuICBVU05JQ19V
RFAgaXMganVzdCBVRFAuDQoNCj4gV2VsbCwgaWYgUm9DRXYyIHVzZXMgdGhlIHNhbWUgcHJvdG9j
b2wgZW51bSwgdGhhdCBtYXkgaW50cm9kdWNlIG5ldw0KPiBjb25mdXNpb24sIGZvciBleGFtcGxl
IHRoZXJlIHdpbGwgYmUgc29tZSBuZXcgQ00gaGFuZGxpbmcgZm9yIFVEUCBlbmNhcCwNCj4gc291
cmNlIHBvcnQgc2VsZWN0aW9uLCBhbmQgb2YgY291cnNlIHZsYW4vdGFnIGFzc2lnbm1lbnQsIGV0
Yy4gQnV0IGlmDQo+IHRoZXJlIGlzIHN1cHBvcnQgdW5kZXIgd2F5LCBhbmQgZXZlcnlvbmUgaXMg
Y2xlYXIsIHRoZW4sIG9rLg0KDQpSb0NFdjIvSUJvVURQIHNoYXJlcyB0aGUgc2FtZSBwb3J0IHNw
YWNlIGFzIFVEUC4gIEl0IGhhcyBhIHNpbWlsYXIgaXNzdWVzIGFzIGlXYXJwIGRvZXMgc2hhcmlu
ZyBzdGF0ZSB3aXRoIHRoZSBtYWluIG5ldHdvcmsgc3RhY2suICBJJ20gbm90IGF3YXJlIG9mIGFu
eSBwcm9wb3NhbCBmb3IgcmVzb2x2aW5nIHRoYXQuICBEb2VzIGl0IHJlcXVpcmUgdXNpbmcgYSBz
ZXBhcmF0ZSBJUCBhZGRyZXNzPyAgRG9lcyBpdCB1c2UgYSBwb3J0IG1hcHBlciBmdW5jdGlvbj8g
IERvZXMgbmV0ZGV2IGNhcmUgZm9yIFVEUD8gIEknbSBub3Qgc3VyZSB3aGF0IFVTTklDIGRvZXMg
Zm9yIHRoaXMgZWl0aGVyLCBidXQgYSBjb21tb24gc29sdXRpb24gYmV0d2VlbiBVU05JQyBhbmQg
SUJvVURQIHNlZW1zIHJlYXNvbmFibGUuDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
