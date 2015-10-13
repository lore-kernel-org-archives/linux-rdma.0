From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating
 AH from WC
Date: Tue, 13 Oct 2015 16:18:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
	<1444568298-17289-2-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBPbiBNb24sIE9jdCAxMiwgMjAxNSBhdCA3OjQyIFBNLCBIZWZ0eSwgU2VhbiA8c2Vhbi5oZWZ0
eUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+PiBXaGVuIElQIGJhc2VkIGFkZHJlc3Npbmcgd2FzIGlu
dHJvZHVjZWQsIGliX2NyZWF0ZV9haF9mcm9tX3djIHdhcw0KPiA+PiBjaGFuZ2VkIGluIG9yZGVy
IHRvIHN1cHBvcnQgYSBzdWl0YWJsZSBBSC4gU2luY2UgdGhpcyBBSCBzaG91bGQNCj4gPj4gbm93
IGNvbnRhaW5zIHRoZSBETUFDICh3aGljaCBpc24ndCBhIHNpbXBsZSBkZXJpdmF0aXZlIG9mIHRo
ZSBHSUQpLg0KPiA+PiBJbiBvcmRlciB0byBmaW5kIHRoZSBETUFDLCBhbiBBUlAgc2hvdWxkIHNv
bWV0aW1lIGJlIHNlbnQuIFRoaXMgQVJQDQo+ID4+IGlzIGEgc2xlZXBpbmcgY29udGV4dC4NCj4g
Pg0KPiA+IFdhaXQgLSBhcmUgeW91IHNheWluZyB0aGF0IHRoZSBDTSBtYXkgbm93IGJlIHdhaXRp
bmcgZm9yIGFuIEFSUCByZXNwb25zZQ0KPiBiZWZvcmUgaXQgY2FuIHNlbmQgYSBtZXNzYWdlPw0K
PiA+DQo+IA0KPiBpYl9jcmVhdGVfYWhfZnJvbV93YyBuZWVkcyB0byByZXNvbHZlIHRoZSBETUFD
IGluIG9yZGVyIHRvIGNyZWF0ZSB0aGUNCj4gQUggKHRoaXMgbWF5IHJlc3VsdCBzZW5kaW5nIGFu
IEFSUCBhbmQgd2FpdGluZyBmb3IgcmVzcG9uc2UpLg0KPiBDTSB1c2VzIHRoaXMgZnVuY3Rpb24g
KHdoaWNoIGlzIG5vdyBzbGVlcGFibGUpLg0KDQpUaGlzIGlzIGEgc2lnbmlmaWNhbnQgY2hhbmdl
IHRvIHRoZSBDTS4gIFRoZSBDTSBjYWxscyBhcmUgaW52b2tlZCBhc3N1bWluZyB0aGF0IHRoZXkg
cmV0dXJuIHJlbGF0aXZlbHkgcXVpY2tseS4gIFRoZXkncmUgaW52b2tlZCBmcm9tIGNhbGxiYWNr
cyBhbmQgaW50ZXJuYWxseS4gIEhhdmluZyB0aGUgY2FsbHMgbm93IHdhaXQgZm9yIGFuIEFSUCBy
ZXNwb25zZSByZXF1aXJlcyB0aGF0IHRoaXMgYmUgcmUtYXJjaGl0ZWN0ZWQsIHNvIHRoZSBjYWxs
aW5nIHRocmVhZCBkb2Vzbid0IGdvIG91dCB0byBsdW5jaCBmb3Igc2V2ZXJhbCBzZWNvbmRzLg0K
DQotIFNlYW4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
