From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets and fork
Date: Thu, 23 Aug 2012 01:32:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8A7D5@ORSMSX101.amr.corp.intel.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	 <502A9039.4090505@us.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
	 <1344968289.2101.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
	 <1345239625.1128.20.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com>
 <1345681858.25565.12.camel@oc1677441337.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345681858.25565.12.camel-5vSEHtyIv2TJ4MwkZ4db91aTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBJIHNhdyB0aGlzIGNvZGUgaW4gcHJlbG9hZCBsaWJyYXJ5IGFuZCB3YXMgd29uZGVyaW5nIHdo
eSByc29ja2V0KCkgaXMgY2FsbGVkDQo+IGFuZCBjbG9zZWQgaW1tZWRpYXRlbHkgaWYgZm9ya19z
dXBwb3J0IGlzIGVuYWJsZWQuIEkgZ3Vlc3MgeW91IGFyZSBkb2luZyB0aGlzDQo+IHNvIHRoYXQg
eW91IGNhbiBmYWxsYmFjayB0byByZWFsIHNvY2tldCBhdCB0aGUgaW5pdGlhbCBzb2NrZXQoKSBj
YWxsIGluc3RlYWQNCj4gb2Ygd2FpdGluZyBhbGwgdGhlIHdheSB1bnRpbCBmb3JrX2FjdGl2ZS9m
b3JrX3Bhc3NpdmUuIFRoaXMgc2hvdWxkIGJlIE9LDQo+IHNwZWNpZmljYWxseSBpZiBhIHVzZXIg
aXMgdXNpbmcgcHJlbG9hZCBsaWJyYXJ5IGFuZCBlbmFibGluZyBmb3JrX3N1cHBvcnQuDQoNClRo
ZSBpbml0aWFsIGNhbGwgdG8gcnNvY2tldCgpIGlzIG1hZGUgdG8gc2VlIGlmIHRoYXQgc29ja2V0
IHR5cGUgaXMgZW5hYmxlZC4gIFRoaXMgd2F5IEkgZG9uJ3QgbmVlZCB0byB1cGRhdGUgYm90aCBy
c29ja2V0IGFuZCB0aGUgcHJlbG9hZCBsaWJyYXJ5IHdoZW4gbmV3IHNvY2tldCB0eXBlcyBhcmUg
c3VwcG9ydGVkLiAgU28sIHllcywgaXQgYWxsb3dzIHVzIHRvIGZhbGxiYWNrIHRvIGEgbm9ybWFs
IHNvY2tldCBxdWlja2x5IGlmIHJzb2NrZXRzIGRvZXMgbm90IHN1cHBvcnQgdGhlIHJlcXVlc3Rl
ZCB0eXBlLg0KIA0KPiBUaGlzIGRvZXNuJ3QgbG9vayBsaWtlIGEgaGFjayB0byBtZS4gSG93ZXZl
ciBpdCBsb29rcyBsaWtlIGEgYnVnIGlmIHJzb2NrZXQoKQ0KPiBmb2xsb3dlZCBieSByY2xvc2Uo
KSBkb2Vzbid0IGNsZWFudXAgYWxsIHRoZSByZXNvdXJjZXMgY29ycmVjdGx5Lg0KDQpJIGNhbiBj
b21lIHVwIHdpdGggc29tZXRoaW5nIGEgbGl0dGxlIGNsZWFuZXIsIHdoaWNoIEkgdGhpbmsgd291
bGQgd29yayBva2F5LiAgSSdtIGp1c3Qgd29uZGVyaW5nIGlmIHRoaXMgaXNuJ3QgcmVhbGx5IGFu
IGlzc3VlIHdpdGggbGlibWx4NCBzdXBwb3J0aW5nIGZvcmsoKS4gIEkganVzdCBuZWVkIHNvbWUg
d2F5IHRvIGNvbmZpcm0gdGhhdCB0aGlzIGlzIHRoZSBjYXVzZSBvZiB0aGUgaGFuZ3MuDQoNClJl
Z2FyZGxlc3MsIEknbGwgdHJ5IHRvIHB1c2ggaW4gYSBwYXRjaCBieSB0aGUgZW5kIG9mIHRoZSB3
ZWVrIHdpdGggdGhpcyBmaXguDQoNClRoYW5rcyBmb3IgeW91ciBoZWxwIQ0KDQotIFNlYW4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
