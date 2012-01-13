From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/13] DAPL v2.0: scm: return correct event error code when
 remote host refuses requests
Date: Fri, 13 Jan 2012 23:54:57 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F92AF81976@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Y2hhbmdlZCBmcm9tIFRJTUVPVVQgdG8gTk9OX1BFRVJfUkVKRUNURUQNCg0KU2lnbmVkLW9mZi1i
eTogQXJsaW4gRGF2aXMgPGFybGluLnIuZGF2aXNAaW50ZWwuY29tPg0KLS0tDQogZGFwbC9vcGVu
aWJfc2NtL2NtLmMgfCAgICAyICstDQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kYXBsL29wZW5pYl9zY20vY20uYyBiL2Rh
cGwvb3BlbmliX3NjbS9jbS5jDQppbmRleCBiNDVhNGFiLi41ODZlMWIwIDEwMDY0NA0KLS0tIGEv
ZGFwbC9vcGVuaWJfc2NtL2NtLmMNCisrKyBiL2RhcGwvb3BlbmliX3NjbS9jbS5jDQpAQCAtNTc4
LDcgKzU3OCw3IEBAIHN0YXRpYyB2b2lkIGRhcGxpX3NvY2tldF9jb25uZWN0ZWQoZHBfaWJfY21f
aGFuZGxlX3QgY21fcHRyLCBpbnQgZXJyKQ0KIGJhaWw6DQogCS8qIG1hcmsgQ00gb2JqZWN0IGZv
ciBjbGVhbnVwICovDQogCWRhcGxpX2NtX2ZyZWUoY21fcHRyKTsNCi0JZGFwbF9ldmRfY29ubmVj
dGlvbl9jYWxsYmFjayhOVUxMLCBJQl9DTUVfVElNRU9VVCwgTlVMTCwgMCwgZXBfcHRyKTsNCisJ
ZGFwbF9ldmRfY29ubmVjdGlvbl9jYWxsYmFjayhOVUxMLCBJQl9DTUVfREVTVElOQVRJT05fUkVK
RUNULCBOVUxMLCAwLCBlcF9wdHIpOw0KIH0NCiANCiAvKg0KLS0gDQoxLjcuMw0KDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
