From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/5] IB: Switch from struct ib_dma_mapping_ops to struct
 dma_mapping_ops
Date: Mon, 19 Dec 2016 16:55:06 +0000
Message-ID: <1482166487.25336.10.camel@sandisk.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
         <25d066c2-59d7-2be7-dd56-e29e99b43620@sandisk.com>
         <20161209182429.GF16622@lst.de>
         <52e8398f-a146-721c-3b92-0892b4abbff8@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52e8398f-a146-721c-3b92-0892b4abbff8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <A498A802C3317749AFDB4154D03964E7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE2LTEyLTE5IGF0IDExOjQyIC0wNTAwLCBEZW5uaXMgRGFsZXNzYW5kcm8gd3Jv
dGU6DQo+IE9uIDEyLzA5LzIwMTYgMDE6MjQgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0K
PiA+ID4gQWRkaXRpb25hbGx5LCB1c2UgZG1hX25vb3Bfb3BzIGluc3RlYWQgb2YgZHVwbGljYXRp
bmcgaXQuDQo+ID4gDQo+ID4gT29wcywgSSBkb24ndCB0aGluayB0aGF0IHBhcnQgYWN0dWFsbHkg
aXMgY29ycmVjdC4gIEJvdGggcmRtYXZ0DQo+ID4gYW5kIHRoZSB3ZWlyZCBpbnRlbCBkcml2ZXJz
IHdhbnQgdGhlIF92aXJ0dWFsXyBhZGRyZXNzIGluIHRoZWlyIGRtYQ0KPiA+IGFkZHJlc3MgaW5z
dGVhZCBvZiB0aGUgcGh5c2ljYWwgb25lIHNldCBieSBkbWFfbm9vcF9vcHMuDQo+IA0KPiBZZXMs
IENocmlzdG9waCBpcyBjb3JyZWN0IGluIHRoYXQgb3VyIGRyaXZlcnMgdXNlIHRoZSB2aXJ0dWFs
IGFkZHJlc3MuIA0KPiBJdCB3b3VsZCByZXF1aXJlIG1vcmUgY2hhbmdlcyBpbiB0aGUgcmVzdCBv
ZiB0aGUgZHJpdmVyIHRvIG1ha2UgaXQgdXNlIA0KPiB0aGUgcGh5c2ljYWwgYWRkcmVzcy4gUG9z
c2libGUgSSB0aGluaywgYnV0IG1vcmUgd29yay4NCg0KSGVsbG8gRGVubnksDQoNCk9uY2UgdGhl
IHY0LjEwIG1lcmdlIHdpbmRvdyBoYXMgY2xvc2VkIGFuZCB2NC4xMC1yYzEgaXMgb3V0IEkgd2ls
bA0KcmVwb3N0IHRoaXMgcGF0Y2ggc2VyaWVzLiBJIHdpbGwgbWFrZSBzdXJlIHdoZW4gSSByZXBv
c3QgdGhpcyBwYXRjaA0Kc2VyaWVzIHRoYXQgdGhlIERNQSBjb2RlIGZvciB0aGUgUkRNQSBkcml2
ZXJzIHRvdWNoZWQgYnkgdGhpcyBwYXRjaA0Kc2VyaWVzIHVzZXMgdmlydHVhbCBhZGRyZXNzZXMg
aW5zdGVhZCBvZiBwaHlzaWNhbC4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
