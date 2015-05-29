From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 17:18:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE2149@ORSMSX109.amr.corp.intel.com>
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
	 <1828884A29C6694DAF28B7E6B8A82373A8FE2126@ORSMSX109.amr.corp.intel.com>
 <1432919688.114391.116.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432919688.114391.116.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUaGUgdXNlIGNhc2UgaXMgY2xlYXIgSU1PLiAgSXQncyBmb3IgZmluYW5jaWFsIHRyYWRpbmcg
c29mdHdhcmUuICBJDQo+IGRvbid0IHRoaW5rIHRoZXkgcmVhbGx5IGNhcmUgYWJvdXQgZGV0YWls
cyBsaWtlIHdoZXRoZXIgaXQncyB0aGUgc3RhcnQNCj4gb3IgZW5kIHBhY2tldCwgb3IgY29tcGxl
dGlvbiwgb3Igd2hhdGV2ZXIuICBUaGV5IG5lZWQgYSB0aWUgYnJlYWtlcg0KPiBiZXR3ZWVuIHdo
ZW4gdGhleSBoYXZlIHR3byBkaWZmZXJlbnQgYnV5IG9yIHNlbGwgb3JkZXJzIG9uIHRoZSBzYW1l
IGxvdA0KPiBvZiBzdG9jay4gIEFueSBkZXRlcm1pbmlzdGljIHRpbWluZy9vcmRlcmluZyBtZXRo
b2Qgd2lsbCBkbyBhcyBsb25nIGFzDQo+IHRoZXkgY29uc2lzdGVudGx5IGFwcGx5IGl0IEkgdGhp
bmsuICBBbmQgdGhlIGZhc3RlciBhbmQgbG93ZXIgb3ZlcmhlYWQNCj4gdGhlIHByb2Nlc3MsIHRo
ZSBiZXR0ZXIuICBIZSBkb2Vzbid0IHJlYWxseSB3YW50IGEgdGltZXN0YW1wLCBoZSBtZXJlbHkN
Cj4gd2FudHMgYSBzZXF1ZW5jZSBvcmRlcmluZy4gIEJ1dCBhIHRpbWVzdGFtcCBpcyB3aGF0IHRo
ZXkgYXJlIHVzaW5nIHRvDQo+IGdldCBoaW0gd2hhdCBoZSBuZWVkcy4NCj4gDQo+IElzIHRoYXQg
YSBmYWlyIGd1ZXNzIENocmlzdG9waD8NCg0KSSBnZXQgQ2hyaXN0b3BoJ3MgdXNhZ2UgbW9kZWwu
ICBCdXQgQUZBSUssIGhlIHVzZXMgVUQgcGFja2V0cywgb2Z0ZW4gd2l0aCBtdWx0aWNhc3QuICBT
byB0aGUgdGltZXN0YW1wIGVuZHMgdXAgYXNzb2NpYXRlZCBpbmRpcmVjdGx5IHdpdGggYW4gYWN0
dWFsIHBhY2tldC4gIFRoYXQgbW9kZWwgbWFrZXMgc2Vuc2UgdG8gbWUuICBJdOKAmXMgdGhlIGdl
bmVyaWMgdGltZSBzdGFtcGluZyBvZiBhIHdvcmsgY29tcGxldGlvbiAoZm9yLCBzYXksIGEgMiBH
QiB0cmFuc2ZlciBvdmVyIFJDIHVzaW5nIGFuIFNSUSkgdGhhdCBkb2Vzbid0IG1ha2Ugc2Vuc2Ug
dG8gbWUuICBUaGF0J3MgdGhlIHBhcnQgSSdtIHN0cnVnZ2xpbmcgd2l0aC4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
