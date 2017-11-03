From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ
 to using RC
Date: Fri, 3 Nov 2017 13:05:27 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC6266BEA7@fmsmsx120.amr.corp.intel.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
         <20171011172729.16984-5-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC6266931A@fmsmsx120.amr.corp.intel.com>
 <1509658914.2484.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509658914.2484.21.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiANCj4gU29ycnkgZm9yIHRoaXMuIFNpbmNlIEkgYXNzdW1lIHRoYXQgeW91IGFyZSByZWZlcnJp
bmcgdG8gdGVzdHMgd2l0aCB0aGUgcWliDQo+IG9yIGhmaTEgZHJpdmVyIGFuZCBzaW5jZSBJIGRv
IG5vdCBoYXZlIGFjY2VzcyB0byBhIHNldHVwIHdpdGggdGhhdCBoYXJkd2FyZQ0KPiBJIHdpbGwg
aGF2ZSB0byByZWx5IG9uIHlvdSBmb3IgZnVydGhlciBhbmFseXNpcy4NCg0KSSB0dXJuZWQgb24g
c29tZSBzdGF0aWMgdHJhY2luZyBhbmQgdGhlcmUgaXMgYSBzZXF1ZW5jZSBvZiBSTlIgbmFrcyBv
biB0aGUgd2lyZSBmcm9tIHRoZSB0YXJnZXQuDQoNCkEgY3Vyc29yeSBsb29rIGF0IHRoZSBub3Jt
YWwgQUNLIGFldGggZG9lc24ndCBzaG93IGFueSBpc3N1ZSB3aXRoIHRoZSBmbG93IGNvbnRyb2wu
DQoNCkFnYWluLCBzdGlsbCBsb29raW5nLg0KDQpJIGRvbid0IGtub3cgaWYgcWliIGZhaWxzLCBi
dXQgSSBzdXNwZWN0IGl0IHdpbGwuDQoNCldlIGhhdmUgbmlnaHRseSAxMiBob3VyIHRlc3RzIG9u
IHRoZSBsYXN0ZXN0IHN0dWZmIHRoYXQgY2F1Z2h0IGl0Lg0KDQo+IA0KPiA+IEknbSBsb29raW5n
IGF0IHdoeSBidXQuLi4NCj4gPg0KPiA+ID4gQWRkIG5ldyBjb25maWdmcyBhdHRyaWJ1dGVzIHRo
YXQgYWxsb3cgdG8gY29uZmlndXJlIHdoaWNoIG1vZGUgdG8gdXNlDQo+ID4gPiAoL3N5cy9rZXJu
ZWwvY29uZmlnL3RhcmdldC9zcnB0LyRHVUlELyRHVUlEL2F0dHJpYi91c2Vfc3JxKS4gTm90ZToN
Cj4gPiA+IG9ubHkgdGhlIGF0dHJpYnV0ZSBmb3IgcG9ydCAxIGlzIHJlbGV2YW50IG9uIG11bHRp
LXBvcnQgYWRhcHRlcnMuDQo+ID4NCj4gPiBJdCBsb29rcyBsaWtlIHRoZSBhYm92ZSB3b3JrIGFy
b3VuZCBjYW5ub3Qgd29yay4NCj4gPiBUaGUgdXNlX3NycSBpcyB0ZXN0ZWQgYW5kIHRoZSAgU1JR
IGlzIGFsbG9jYXRlZCB3aGVuIHRoZSBkZXZpY2UgaXMgYWRkZWQuDQo+ID4gU2V0dGluZyBhIHRh
cmdldCByZWxhdGl2ZSBhdHRyaWJ1dGUgaXMgdG9vIGxhdGUgaW4gdGhlIHNlcXVlbmNlIHRvIGVu
YWJsZQ0KPiA+IHRoZSBvbGQgU1JRIHVzYWdlLg0KPiANCj4gVGhhbmtzIGZvciB0aGUgcmVwb3J0
LiBJIHdpbGwgcG9zdCBhIHBhdGNoIHNlcmllcyB0byBhZGRyZXNzIHRoaXMuDQo+IA0KDQpPay4N
Cg0KRm9yIG5vdyBJIGNhbiBqdXN0IG1hbnVhbGx5IGRpc2FybSB3aXRoIGEgY29kZSBjaGFuZ2Ug
dG8gZXhwZXJpbWVudC4NCg0KTWlrZQ0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
