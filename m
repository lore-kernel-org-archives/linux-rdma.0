From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Thu, 28 May 2015 15:58:14 +0000
Message-ID: <HE1PR05MB141865D768E90021C67968B0B1CA0@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com>
	 <555486CA.8080409@dev.mellanox.co.il>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDA931@ORSMSX109.amr.corp.intel.com>
	 <55586E5D.1030801@dev.mellanox.co.il>
	 <1828884A29C6694DAF28B7E6B8A82373A8FDC9A4@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418D0CE0E031DA35E3DDEBAB1C30@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <1432743174.28905.231.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432743174.28905.231.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBGcm9tOiBEb3VnIExlZGZvcmQgW21haWx0bzpkbGVkZm9yZEByZWRoYXQuY29tXQ0KDQo+ID4g
SSBzdXBwb3NlIHRoYXQgdGhlIG1haW4gaXNzdWUgd291bGQgYmUgaGFuZGxpbmcgZXhpc3Rpbmcg
dXNlciBtZW1vcnkNCj4gbWFwcGluZ3MsDQo+ID4gd2hpY2ggY2Fubm90IGJlIGp1c3QgaW52YWxp
ZGF0ZWQgLS0gdGhlIHVzZXItc3BhY2UgZHJpdmVyIG1heSBub3QgYmUgYXdhcmUNCj4gb2YgdGhl
DQo+ID4gZGV2aWNlIHJlbW92YWwgYW5kIG1heSBhY2Nlc3MgdGhpcyBtZW1vcnkgY29uY3VycmVu
dGx5LCBhbmQgd2UgZG9uJ3QNCj4gd2FudCBpdA0KPiA+IHRvIGNyYXNoLg0KPiANCj4gSW4gdGhp
cyBjYXNlLCB5b3UgYXJlIG1hcHBpbmcgaXQgb3V0IG9mIHRoZSBkZXZpY2UgQkFSIHNwYWNlIGFu
ZCBpbnRvIGENCj4gcmFuZG9tIGtlcm5lbCBwYWdlLCB5ZXM/ICBTbywgaWYgdGhlIGRyaXZlciBk
b2Vzbid0IGNhdGNoIHRoZQ0KPiBEUklWRVJfRkFUQUwgZXZlbnQgYW5kIHByb2Nlc3MgdGhhdCB0
byBtZWFuICJkb24ndCBib3RoZXIgdG91Y2hpbmcgdGhpcw0KPiBSRE1BIGRldmljZSBhbnkgbW9y
ZSIsIGl0J3MgZ29pbmcgdG8gd3JpdGUgdG8gYSBtYWlsYm94IHRoYXQgbm8gbG9uZ2VyDQo+IHJl
c3BvbmRzIGFuZCBoYXZlIGluZmluaXRlIHRpbWVvdXRzLCB5ZXM/ICBFc3NlbnRpYWxseSBtZWFu
aW5nIGFsbA0KPiBtYWlsYm94IHR5cGUgb3BlcmF0aW9ucyBqdXN0IGdvIGludG8gbGFsYSBsYW5k
IGZyb20gaGVyZSBvbiBvdXQsIHJpZ2h0Pw0KDQpUaGUga2VybmVsIGFjdGl2aXR5IGlzIGFzeW5j
aHJvbm91cyB0byB1c2VyLXNwYWNlLg0KVGhlIGRldmljZSBtYXkgYmUgdW4tcGx1Z2dlZCBiZWZv
cmUgdGhlIHVzZXItc3BhY2UgZHJpdmVyIGhhcyBhIGNoYW5jZSB0byBsZWFybiB0aGF0IGEgREVW
SUNFX0ZBVEFMIGV2ZW50IGhhcyBvY2N1cnJlZC4gSW4gZmFjdCwgaW4gdGhlIGN1cnJlbnQgdXNl
ci1zcGFjZSBzdGFjayBkZXNpZ24sIGRldmljZSBkcml2ZXJzIGRvbid0IGhhdmUgYSBjb250ZXh0
IG9mIHRoZWlyIG93biB0byByZWFkKCkgZnJvbSBmaWxlIGRlc2NyaXB0b3JzIGFuZCByZWx5IG9u
IHRoZSBhcHBsaWNhdGlvbiBmb3IgdGhhdC4NCkJ1dCBldmVuIHNvLCB5b3UgcHJvYmFibHkgZG9u
J3Qgd2FudCBhIGRyaXZlciB0byBpbnZva2UgYSBzeXN0ZW0gY2FsbCBkdXJpbmcgdGhlIGZhc3Qg
cGF0aCBqdXN0IHRvIA0KDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
