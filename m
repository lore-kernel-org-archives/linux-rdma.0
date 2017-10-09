From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Mon, 9 Oct 2017 17:01:33 +0000
Message-ID: <1507568492.2674.11.camel@wdc.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
         <20171006214243.11296-4-bart.vanassche@wdc.com>
         <20171008100317.GR25829@mtr-leonro.local>
         <1507568205.46071.46.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507568205.46071.46.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <4DD0D808371C5A4690B009D8F5F77152-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTEwLTA5IGF0IDEyOjU2IC0wNDAwLCBEb3VnIExlZGZvcmQgd3JvdGU6DQo+
IE9uIFN1biwgMjAxNy0xMC0wOCBhdCAxMzowMyArMDMwMCwgTGVvbiBSb21hbm92c2t5IHdyb3Rl
Og0KPiA+IEl0IGlzIGEgbGl0dGxlIGJpdCBzdHJhbmdlIHRvIGFzayBmcm9tIHVzZXIgdG8gZGVj
aWRlIGlmIGhpcyBhZGFwdGVyDQo+ID4gc3VwcG9ydHMgU1JRIG9yIG5vdC4NCj4gPiANCj4gPiBJ
dCBzaG91bGQgYmUgYXV0b21hdGljYWxseS4NCj4gDQo+IEkgdGhpbmsgQmFydCdzIGludGVudCBp
cyB0aGF0IHRoZSBkcml2ZXIgbm90IHVzZSBTUlEgYXMgdGhlIGRlZmF1bHQNCj4gYmVoYXZpb3Ig
ZXZlbiBpZiB0aGUgYWRhcHRlciBzdXBwb3J0cyBpdCwgc28gcXVlcnlpbmcgdGhlIGFkYXB0ZXIg
Zm9yDQo+IHN1cHBvcnQgYW5kIGVuYWJsaW5nIGl0IGlmIGl0IGV4aXN0cyB3b3VsZCBub3QgYWNo
aWV2ZSBoaXMgZGVzaXJlZA0KPiByZXN1bHQuICBUaGlzIHdvdWxkIHRoZW4gYmUgdXNlZCB0byBv
dmVycmlkZSB0aGF0IGJlaGF2aW9yLiAgSXMgdGhhdA0KPiBjb3JyZWN0IEJhcnQ/DQoNCkhlbGxv
IExlb24gYW5kIERvdWcsDQoNClRoZSBjaGFuZ2VzIHJlYWxpemVkIGJ5IHRoaXMgcGF0Y2ggYXJl
Og0KLSBJbnN0ZWFkIG9mIHVzaW5nIFNSUSBhcyBkZWZhdWx0LCB1c2Ugbm9uLVNSUSBtb2RlIGFz
IGRlZmF1bHQuDQotIElmIFNSUSBoYXMgYmVlbiBjaG9zZW4gYXMgZGVmYXVsdCwgYW5kIGlmIFNS
USBpcyBub3Qgc3VwcG9ydGVkLCBmYWxsIGJhY2sNCiAgdG8gbm9uLVNSUSBtb2RlIChzZWUgYWxz
byB0aGUgaWYgKElTX0VSUihzZGV2LT5zcnEpKSAuLi4gY29kZSkuDQoNClBsZWFzZSBsZXQgbWUg
a25vdyBpZiB5b3UgaGF2ZSBhbnkgZnVydGhlciBxdWVzdGlvbnMgYWJvdXQgdGhpcyBwYXRjaC4N
Cg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
