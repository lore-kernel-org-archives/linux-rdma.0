From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/7] librdmacm/rspreload: Do not block connect when
 supporting fork
Date: Tue, 21 Aug 2012 18:00:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8A321@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8997B@ORSMSX101.amr.corp.intel.com>
	 <1345250413.1128.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A1CF@ORSMSX101.amr.corp.intel.com>
 <1345571022.31684.13.camel@oc1677441337.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345571022.31684.13.camel-5vSEHtyIv2TJ4MwkZ4db91aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBJIGFtIHNlZWluZyBhbm90aGVyIGhhbmcgd2l0aCAyIGNsaWVudHMgZG9pbmcgYmktZGlyZWN0
aW9uYWwgdHJhZmZpYyB0byBhDQo+IHNlcnZlci4NCj4gSSBhbSBjb25zaXN0ZW50bHkgc2VlaW5n
IHRoaXMgaGFuZyB3aXRoIHRoZSBhdHRhY2hlZCB0ZXN0IHByb2dyYW1zLg0KPiANCj4gWW91IGNh
biBzdGFydCB0aGUgc2VydmVyIHVzaW5nDQo+ICAgdGNwX3NlcnZlciAtZCAtZQ0KPiANCj4gYW5k
IHJ1biAyIGNsaWVudHMNCj4gICB0Y3BfY2xpZW50IC1oIDxzZXJ2ZXItaXA+IC1uIDEwMDAwIC1k
IC1lDQo+IA0KPiBDYW4geW91IHRyeSBpdCBvdXQgd2l0aCB5b3VyIElCIHNldHVwPyBJZiB5b3Ug
ZG9uJ3Qgc2VlIHRoaXMgaGFuZywgdGhlbiBpdCBpcw0KPiBwb3NzaWJsZQ0KPiB0aGF0IHRoZSBp
c3N1ZXMgaSBhbSBzZWVpbmcgYXJlIFJvQ0Ugc3BlY2lmaWMuDQoNCkFmdGVyIGxvb2tpbmcgaW50
byBuZXRwZXJmIG1vcmUsIEkgdGhpbmsgaXQgaXMgaGFuZ2luZyBmb3IgbWUuICBXaGVuIHJ1bm5p
bmcgbXVsdGlwbGUgY2xpZW50cyBzaW11bHRhbmVvdXNseSwgYW55IGNsaWVudCBiZXlvbmQgdGhl
IGZpcnN0IGFmdGVyIGZvcmtpbmcgc3RvcHMgc2VuZGluZyBhZnRlciAzMDAtNDAwIG1lc3NhZ2Vz
LiAgSSBoYXZlbid0IGNoZWNrZWQgaG93IG11Y2ggZGF0YSBoYWQgdHJhbnNmZXJyZWQsIHNvIGl0
IG1heSBiZSB0aGUgc2FtZSBhcyB3aGF0IHlvdSByZXBvcnRlZC4gIEknbSBkZWJ1Z2dpbmcgdGhp
cy4NCg0KSSBkb24ndCBoYXZlIHRjcF9jbGllbnQvc2VydmVyIGluc3RhbGxlZCwgc28gSSdsbCBu
ZWVkIHRvIGdldCB0aG9zZS4gIERvZXMgdGhlIHNlcnZlciBjYWxsIGZvcms/DQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
