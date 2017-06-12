From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 20:46:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
 <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <b5279c09-027f-e374-ffde-7f236c52322c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5279c09-027f-e374-ffde-7f236c52322c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IFdoZW4gdHJhbnNtaXR0ZXIgYW5kIHJlY2VpdmVyIGlzIGVuYWJsZWQgdG8gZG8gc28sIGFz
IEkgZGVzY3JpYmVkIGluDQo+IG92ZXJ2aWV3IHNlY3Rpb24gb2YgRG9jdW1lbnRhdGlvbiwgaXQg
aGVscHMNCj4gPiAoYSkgdG8gYXZvaWQgcmV0cmFuc21pc3Npb24gLSBpbXByb3ZlcyBuZXR3b3Jr
IHV0aWxpemF0aW9uDQo+ID4gKGIpIHJlZHVjZXMgbGF0ZW5jeSBkdWUgdG8gdGltZXJzIG5vdCBr
aWNraW5nIGluLg0KPiANCj4gWWVzIHRob3NlIGJlbmVmaXRzIGFyZSBjbGVhci4gSSBzZWUgbm8g
cmVhc29uIHdoeSBpdCBzaG91bGRuJ3QgYWx3YXlzDQo+IGJlDQo+IGRvbmUgaXMgbXkgcG9pbnQu
IEFwcGxpY2F0aW9uIHNob3VsZG4ndCBoYXZlIHRvIGNhcmUgYW5kIHRoZXJlIGlzIG5vDQo+IG5l
ZWQgdG8gbWFrZSB0aGlzIGFuIGFkZGl0aW9uYWwgZmxhZy4NCg0KVGhlIGFwcCBjYXJlcyB3aGVu
IGRhdGEgZnJvbSB3cml0ZSAyIGNhbiBiZSB3cml0dGVuIGF0IHRoZSB0YXJnZXQgYmVmb3JlIGRh
dGEgZnJvbSB3cml0ZSAxLCBlc3BlY2lhbGx5IGlmIHRoZSB3cml0ZXMgdGFyZ2V0IHRoZSBzYW1l
IG1lbW9yeSBidWZmZXJzLiAgKEF0IGxlYXN0IEkgdGhpbmsgdGhpcyBpcyB0aGUgaW50ZW50IG9m
IGV4cG9zaW5nIHRoaXMgdG8gdGhlIGFwcC4pDQoNCk5vdGUgdGhhdCB0aGUgcHJvdmlkZXIgY2Fu
IGFsd2F5cyBwcm92aWRlIHN0cm9uZ2VyIG9yZGVyaW5nIHRoYW4gd2hhdCB0aGUgYXBwIG5lZWRz
Lg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
