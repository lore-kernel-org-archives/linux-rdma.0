From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL
 commands
Date: Thu, 1 Sep 2016 17:17:26 +0000
Message-ID: <1472750241.16467.29.camel@intel.com>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
         <1471987907-6336-7-git-send-email-leon@kernel.org>
         <1472738739.16467.8.camel@intel.com>
         <20160901164624.GC6479@obsidianresearch.com>
         <20160901165552.GE21847@leon.nu>
         <20160901170742.GA20098@obsidianresearch.com>
         <1472749767.16467.25.camel@intel.com>
         <20160901171129.GB19982@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160901171129.GB19982-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <75E42F93D3237C44A8BA4FD34032143A-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE2LTA5LTAxIGF0IDExOjExIC0wNjAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgU2VwIDAxLCAyMDE2IGF0IDA1OjA5OjMxUE0gKzAwMDAsIERhbGVzc2FuZHJv
LCBEZW5uaXMgd3JvdGU6DQo+IA0KPiA+ID4gRGVubmlzIHNob3VsZCB1c2UgYW4gaW50ZXJuYWwg
ZGVmaW5pdGlvbiBpbiBQU00gaWYgaGUgd2lzaGVzIHRvDQo+ID4gPiBjb250aW51ZSB0byBzdXBw
b3J0IHRoZSBzdGFnaW5nIGtlcm5lbCBBQkkuDQo+ID4gDQo+ID4gSXQncyBub3QganVzdCB0aGUg
YmFja3dhcmQgY29tcGF0aWJpbGl0eS4gUFNNIHVzZXMgdGhlc2UgY29tbWFuZA0KPiA+IGRlZmlu
aXRpb25zLlNvIHRoaXMgYnJlYWtzIGN1cnJlbnQgc3VwcG9ydCB3aXRoIGN1cnJlbnQgZHJpdmVy
Lg0KPiANCj4gSG93IGV4YWN0bHk/IFRoZSBIRkkxX0NNRF9BU1NJR05fQ1RYVCBjb25zdGFudCBp
cyBuZXZlciB1c2VkIGluIHRoZQ0KPiBrZXJuZWw/DQoNClRoaXMgaXMgdXNlZCBpbiBQU00gbGli
cmFyeS4gQWdyZWUgaXQncyBub3QgdXNlZCBpbiB0aGUga2VybmVsLCBzbyBJDQpjYW4gc2VlIHRo
ZSBhcmd1bWVudCB0byBnZXQgcmlkIG9mIGl0LCBvciBub3QgY2FyZS4gSG93ZXZlcg0KcmVtb3Zp
bmcvY2hhbmdpbmcgaXQgYnJlYWtzIFBTTSBhbmQgcmVxdWlyZXMgY2hhbmdlcy4gVGhleSBhcmUg
bm90IGhhcmQNCmNoYW5nZXMgdG8gbWFrZSwgYnV0IGFzIGl0IHN0YW5kcyBub3cgUFNNIHdpbGwg
d29yayB3aXRoIDQuNyBidXQgbm90DQp3aXRoIDQuOC4NCg0KUmV2ZXJ0aW5nIHRoaXMgcGFydCBv
ZiB0aGUgcGF0Y2ggZG9lc24ndCBjaGFuZ2Ugb3IgZGV0cmFjdCBmcm9tIHdoYXQNCnRoZSBzZXJp
ZXMgZG9lcyBpbiB0aGUgZmlyc3QgcGxhY2UuIFBhdGNoIHN0aWxsIGFjY29tcGxpc2hlcyBpdHMg
am9iLg0KDQotRGVubnk=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
