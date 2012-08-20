From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/7] librdmacm/rspreload: Do not block connect when
 supporting fork
Date: Mon, 20 Aug 2012 20:22:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8A1CF@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8997B@ORSMSX101.amr.corp.intel.com>
 <1345250413.1128.36.camel@oc1677441337.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345250413.1128.36.camel-5vSEHtyIv2TJ4MwkZ4db91aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBJIGp1c3QgdXBkYXRlZCB0aGUgcmVwb3NpdG9yeSBhbmQgbm90aWNlZCB0aGF0IHdlIGFyZSBm
YWxsaW5nIGJhY2sgdG8NCj4gbm9ybWFsIHNvY2tldHMgZXZlbiB3aXRoIHByZWxvYWQuDQo+IEFm
dGVyIHNvbWUgZGVidWdnaW5nLCBmb3VuZCBhIGNvdXBsZSBvZiBpc3N1c2UuIFNlZSBpbmxpbmUu
DQoNClRoYW5rcyBmb3IgdGhlIHJlcG9ydC4NCg0KSSd2ZSBwdXNoZWQgYSBwYXRjaCB0byB0aGUg
cmVwb3NpdG9yeSB0byBhZGRyZXNzIHRob3NlIGlzc3VlcywgYWxvbmcgd2l0aCBvbmUgb3RoZXIg
cHJvYmxlbSB0aGF0IEkgd2FzIGFibGUgdG8gaGl0LiAgSWYgdGhlIGNvbm5lY3Rpb24gaXMgbm9u
YmxvY2tpbmcsIHRoZW4gZm9ya19hY3RpdmUoKSBjYW4gYmUgY2FsbGVkIGJlZm9yZSB0aGUgY29u
bmVjdGlvbiBoYXMgY29tcGxldGVkLCB3aGljaCBjYW4gcmVzdWx0IGluIGdldHBlZXJuYW1lKCkg
ZmFpbGluZy4NCg0KSSdtIHN0aWxsIG5vdCBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgaGFuZyB0aGF0
IHlvdSB3ZXJlIHNlZWluZywgYnV0IEkgY2FuIHJlcHJvZHVjZSB0aGUgcHJvYmxlbSB3aGVyZSB0
aGUgdGhyb3VnaHB1dCBzdHJvbmdseSBmYXZvcnMgdGhlIGZpcnN0IHByb2Nlc3MgdG8gY29ubmVj
dCBvdmVyIGEgc2Vjb25kIHByb2Nlc3MuICBJJ20gbG9va2luZyBpbnRvIHRoYXQuDQoNCi0gU2Vh
bg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
