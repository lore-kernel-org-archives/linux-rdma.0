From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Thu, 11 Jun 2015 23:52:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FEF321@ORSMSX109.amr.corp.intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
  <1433615915-24591-15-git-send-email-ira.weiny@intel.com>
  <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
  <1433961446.71666.26.camel@redhat.com>
  <20150610185653.GA28153@obsidianresearch.com>
 <1433966378.71666.44.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FEF1EA@ORSMSX109.amr.corp.intel.com>
 <557A18C0.6010200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557A18C0.6010200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IEkgYWdyZWUgdGhhdCB0aGUgbm9kZSB0eXBlIGVudW0gaXNuJ3QgcGFydGljdWxhcmx5IHVz
ZWZ1bCBhbmQgc2hvdWxkIGJlDQo+IHJldGlyZWQuDQo+IA0KPiBBcmUgeW91IHJlZmVycmluZyB0
byBrZXJuZWwgc3BhY2Ugb3IgdXNlciBzcGFjZSBvciBib3RoID8NCg0KU2hvcnQgdGVybSwga2Vy
bmVsIHNwYWNlLiAgVXNlciBzcGFjZSBuZWVkcyB0byBrZWVwIHNvbWV0aGluZyBhcm91bmQgZm9y
IGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5Lg0KDQpCdXQgdGhlIGluIHRyZWUgY29kZSB3aWxsIG5l
dmVyIGV4cG9zZSB0aGlzIHZhbHVlIHVwLg0KDQo+ID4gQnV0IGV2ZW4gaWYgd2UgZG8sIEknbSBu
b3Qgc3VyZSB0aGlzIGlzIHRoZSBjb3JyZWN0IGFwcHJvYWNoLiAgSSBkb24ndA0KPiBrbm93IHRo
aXMgZm9yIGEgZmFjdCwNCj4gPiBidXQgaXQgc2VlbXMgbW9yZSBsaWtlbHkgdGhhdCBzb21lb25l
IHdvdWxkIGVtYmVkIExpbnV4IG9uIGFuIElCIHN3aXRjaA0KPiB0aGFuIHRoZXkgd291bGQgcGx1
ZyBhbiBJQiBzd2l0Y2gNCj4gPiBpbnRvIGEgTGludXggYmFzZWQgc3lzdGVtLiAgVGhlIGNvZGUg
aXMgZGVzaWduZWQgYXJvdW5kIHRoZSBsYXR0ZXIuDQo+IE1ha2luZyB0aGlzIGEgc3lzdGVtIHdp
ZGUgc2V0dGluZyBtaWdodCBzaW1wbGlmeSB0aGUgY29kZSBhbmQgb3B0aW1pemUgdGhlDQo+IGNv
ZGUgcGF0aHMuDQo+IA0KPiBJIHRoaW5rIHdlIG5lZWQgdG8gZGlzY3VzcyBob3cgdXNlciBzcGFj
ZSB3b3VsZCBiZSBhZGRyZXNzZWQuDQoNClRoaXMgaXMgYW4gaXNzdWUgd2l0aCBvdXQgb2YgdHJl
ZSBkcml2ZXJzLiAgV2UncmUgaGF2aW5nIHRvIGd1ZXNzIHdoYXQgdGhpbmdzIG1pZ2h0IGJlIGRv
aW5nLiAgQXJlIGFsbCBkZXZpY2VzIGJlaW5nIGV4cG9zZWQgdXAgYXMgYSAnc3dpdGNoJywgb3Ig
aXMgdGhlcmUgZXZlciBhIGNhc2Ugd2hlcmUgdGhlcmUncyBhICdzd2l0Y2gnIGRldmljZSBhbmQg
YW4gSENBIGRldmljZSBiZWluZyByZXBvcnRlZCB0b2dldGhlciwgb3IgKGhpZ2hseSB1bmxpa2Vs
eSkgYSBzd2l0Y2ggZGV2aWNlIGFuZCBhbiBSTklDPw0KDQpJZiB0aGUgcmVhbCB1c2UgY2FzZSBp
cyB0byBlbWJlZCBMaW51eCBvbiBhIHN3aXRjaCwgdGhlbiB3ZSBjb3VsZCBsb29rIGF0IG1ha2lu
ZyB0aGF0IGEgc3lzdGVtIHdpZGUgc2V0dGluZywgcmF0aGVyIHRoYW4gcGVyIGRldmljZS4gIFRo
aXMgY291bGQgY2xlYW4gdXAgdGhlIGtlcm5lbCB3aXRob3V0IGltcGFjdGluZyB0aGUgdUFCSS4N
Cg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
