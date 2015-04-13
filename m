From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
Date: Mon, 13 Apr 2015 19:25:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB60F.60109@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552BB60F.60109-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBAQCAtMTAzNywxNyArMTAzMywxMyBAQCB2b2lkIHJkbWFfZGVzdHJveV9pZChzdHJ1Y3QgcmRt
YV9jbV9pZCAqaWQpDQo+ICAJbXV0ZXhfdW5sb2NrKCZpZF9wcml2LT5oYW5kbGVyX211dGV4KTsN
Cj4gDQo+ICAJaWYgKGlkX3ByaXYtPmNtYV9kZXYpIHsNCj4gLQkJc3dpdGNoIChyZG1hX25vZGVf
Z2V0X3RyYW5zcG9ydChpZF9wcml2LT5pZC5kZXZpY2UtDQo+ID5ub2RlX3R5cGUpKSB7DQo+IC0J
CWNhc2UgUkRNQV9UUkFOU1BPUlRfSUI6DQo+ICsJCWlmIChyZG1hX2liX29yX2lib2UoaWRfcHJp
di0+aWQuZGV2aWNlLCBpZF9wcml2LT5pZC5wb3J0X251bSkpDQoNCkEgbGlzdGVuIGlkIGNhbiBi
ZSBhc3NvY2lhdGVkIHdpdGggYSBkZXZpY2Ugd2l0aG91dCBiZWluZyBhc3NvY2lhdGVkIHdpdGgg
YSBwb3J0IChzZWUgdGhlIGxpc3Rlbl9hbnlfbGlzdCkuICBTb21lIG90aGVyIGNoZWNrIGlzIG5l
ZWRlZCB0byBoYW5kbGUgdGhpcyBjYXNlLiAgSSBndWVzcyB0aGUgY29kZSBjb3VsZCBjaGVjayB0
aGUgZmlyc3QgcG9ydCBvbiB0aGUgZGV2aWNlIChyZXBsYWNlIHBvcnRfbnVtIHdpdGggaGFyZGNv
ZGVkIHZhbHVlIDEpLiAgVGhlbiB3ZSB3b3VsZG4ndCBiZSBhbnkgbW9yZSBicm9rZW4gdGhhbiB0
aGUgY29kZSBhbHJlYWR5IGlzLiAgKFRoZSAnYnJlYWsnIGlzIGNvbmNlcHR1YWwsIG5vdCBwcmFj
dGljYWwuKQ0KDQpUaGlzIGFwcGVhcnMgdG8gYmUgaGlnaGxpZ2h0aW5nIGFuIGFyY2hpdGVjdHVy
YWwgZmxhdyBpbiB0aGUgaWJvZSBpbnRlZ3JhdGlvbi4NCg0KPiB7DQo+ICAJCQlpZiAoaWRfcHJp
di0+Y21faWQuaWIpDQo+ICAJCQkJaWJfZGVzdHJveV9jbV9pZChpZF9wcml2LT5jbV9pZC5pYik7
DQo+IC0JCQlicmVhazsNCj4gLQkJY2FzZSBSRE1BX1RSQU5TUE9SVF9JV0FSUDoNCj4gKwkJfSBl
bHNlIGlmIChyZG1hX3RlY2hfaXdhcnAoaWRfcHJpdi0+aWQuZGV2aWNlLA0KPiArCQkJCQkgICBp
ZF9wcml2LT5pZC5wb3J0X251bSkpIHsNCj4gIAkJCWlmIChpZF9wcml2LT5jbV9pZC5pdykNCj4g
IAkJCQlpd19kZXN0cm95X2NtX2lkKGlkX3ByaXYtPmNtX2lkLml3KTsNCj4gLQkJCWJyZWFrOw0K
PiAtCQlkZWZhdWx0Og0KPiAtCQkJYnJlYWs7DQo+ICAJCX0NCj4gIAkJY21hX2xlYXZlX21jX2dy
b3VwcyhpZF9wcml2KTsNCj4gIAkJY21hX3JlbGVhc2VfZGV2KGlkX3ByaXYpOw0KDQogLSBTZWFu
DQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
