From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 21 May 2015 17:48:09 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2FB2@CRSMSX101.amr.corp.intel.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2E96@CRSMSX101.amr.corp.intel.com>
	 <1432228874.28905.35.camel@redhat.com>
 <1432229723.28905.40.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432229723.28905.40.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBPbiBUaHUsIDIwMTUtMDUtMjEgYXQgMTM6MjEgLTA0MDAsIERvdWcgTGVkZm9yZCB3cm90ZToN
Cj4gDQo+IFRoZSBvbmUgdGhpbmcgSSBsZWZ0IG91dCBvZiB0aGUgYWJvdmUgdGhhdCBtaWdodCBi
ZSB3b3J0aCBjaGFuZ2luZyBpcyB0aGUgZmFjdA0KPiB0aGF0IHlvdSBidXJ5IHlvdXIgc2VxdWVu
Y2UgbnVtYmVyIGRvd24gaW4geW91ciBtYWQgaGVhZGVyLiAgSWYgdGhlcmUgaXMgYQ0KPiBnZW5l
cmljIG1lY2hhbmlzbSB0aGF0IG11bHRpcGxlIG1vZHVsZXMgY2FuIHVzZSB0byBzZW5kIGN1c3Rv
bWl6ZWQgZGF0YQ0KPiB2aWEgbmwsIHRoZW4gaXQgbWlnaHQgYmUgd29ydGh3aGlsZSB0byBoYXZl
IHRoZSBzZXF1ZW5jZSBtb3ZlZCB0byB0aGUNCj4gZ2VuZXJpYyBsZXZlbC4NCg0KQWJzb2x1dGVs
eS4gVGhlIG5ldGxpbmsgc2VxdWVuY2UgbnVtYmVyIChmb3IgdGhpcyBtdWx0aWNhc3QgZ3JvdXAp
IHNob3VsZCBiZSBtb3ZlZCB0byBkcml2ZXJzL2luZmluaWJhbmQvY29yZS9uZXRsaW5rLmMgYW5k
IGEgZnVuY3Rpb24gc2hvdWxkIGJlIGV4cG9ydGVkIHRvIGdldCBuZXh0IHNlcXVlbmNlIG51bWJl
ciBzbyB0aGF0IG11bHRpcGxlIG1vZHVsZXMgdXNpbmcgdGhlIHNhbWUgbXVsdGljYXN0IGdyb3Vw
IGNhbiBiZSBtdWx0aXBsZXhlZCBjb3JyZWN0bHkuDQoNCj4gDQo+IA0KPiAtLQ0KPiBEb3VnIExl
ZGZvcmQgPGRsZWRmb3JkQHJlZGhhdC5jb20+DQo+ICAgICAgICAgICAgICAgR1BHIEtleUlEOiAw
RTU3MkZERA0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
