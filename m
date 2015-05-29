From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 17:09:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE2126@ORSMSX109.amr.corp.intel.com>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
	 <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
	 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
	 <20150528162416.GA6515@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
	 <20150528175043.GA10966@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
	 <20150528195034.GA11182@obsidianresearch.com>
	 <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
	 <20150528204749.GA12780@obsidianresearch.com>
	 <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org>
 <1432918170.114391.104.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432918170.114391.104.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBOb3csIGFzIGEgZ2VuZXJhbCBydWxlLCBJIHdvdWxkIGNhbGwgdGltZXN0YW1wcyBnZW5lcmFs
LiAgVGhleSBzaG91bGQgYmUNCj4gYWRkZWQgaW4gYSBmYXNoaW9uIHRoYXQgYW55b25lIGNhbiBp
bXBsZW1lbnQuICBUaGV5IHNob3VsZCBhbHNvIGJlIHdlbGwNCj4gZGVmaW5lZC4gIFNlYW4ncyBx
dWVzdGlvbnMgcmFpc2UgYSB2ZXJ5IHZhbGlkIHBvaW50LiAgRXhhY3RseSB3aGF0IGlzDQo+IGJl
aW5nIHRpbWVzdGFtcGVkLCBhbmQgZG8gd2UgY2FyZSBhYm91dCBkaWZmZXJlbnQgdGltZXN0YW1w
IG9wdGlvbnM/ICBJcw0KPiBpdCBjb21wbGV0aW9uIG9mIG1lc3NhZ2UsIHN0YXJ0IG9mIG1lc3Nh
Z2UsIHRyYW5zZmVyIGZyb20gSENBIHRvIG1haW4NCj4gc3lzdGVtIG1lbW9yeSBjb21wbGV0aW9u
LCBldGMuICBUaGUgMDAvMTAgaGVhZGVyIHRvIHRoaXMgcGF0Y2ggc2VyaWVzDQo+IHdhcyBwcm9i
YWJseSBhbnN3ZXJpbmcgU2VhbidzIHF1ZXN0aW9uLCBidXQganVzdCBiYXNlZCBvbiB0aGUgbmFt
ZSBvZg0KPiB0aGUgVElNRVNUQU1QIGZsYWcgdG8gdGhlIENRIGNyZWF0aW9uIGF0dHIgc3RydWN0
IGl0IGlzbid0IGNsZWFyIHRoYXQNCj4gdGhpcyBpcyB0aGUgY2FzZS4NCg0KSSBkaWRuJ3Qgc2Vl
IHRoZSBpbmZvcm1hdGlvbiB0aGF0IEkgd2FzIGxvb2tpbmcgZm9yIGluIHRoZSBwYXRjaCBoZWFk
ZXIgdG8gdGhpcyBzZXJpZXMuICBBcyBKYXNvbiBwb2ludGVkIG91dCwgdGhlIHVzZSBjYXNlIGlz
IGxhY2tpbmcuDQoNCklNTywgaXQgY291bGQgbWFrZSBqdXN0IGFzIG11Y2ggc2Vuc2UgdG8gYXNz
b2NpYXRlL2VuYWJsZSB0aW1lIHN0YW1waW5nIHdpdGggdGhlIFFQIGFzIHdpdGggdGhlIENRLCBv
ciBldmVuIG1ha2UgaXQgY29uZmlndXJhYmxlIHBlciBvcGVyYXRpb24gb3Igb3BlcmF0aW9uIHR5
cGUuDQoNCklmIENocmlzdG9waCBoYXMgYSBjbGVhciB1c2UgY2FzZSBhbmQgd2FudHMgdG8gZ28g
dG8gdGhlICdiYXJlIG1ldGFsJywgdGhlbiBhIHZlbmRvciBzcGVjaWZpYyBvcHRpb24gc2VlbXMg
aWRlYWwuICBBdCBsZWFzdCB1bnRpbCB0aGVyZSBhcmUgb3RoZXIgaW1wbGVtZW50YXRpb25zIG9y
IHRoZSBkcml2aW5nIHVzZSBjYXNlIGlzIGNsZWFyZXIuDQoNCi0gU2Vhbg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
