From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: common: dat_ep_modify seg faults with null
 ep_param ptr
Date: Wed, 2 Nov 2011 21:34:41 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E93107@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

QWRkIGFkZGl0aW9uYWwgTlVMTCBwdHIgY2hlY2sgZm9yIGFyZzMgZXBfcGFyYW0NCg0KU2lnbmVk
LW9mZi1ieTogQXJsaW4gRGF2aXMgPGFybGluLnIuZGF2aXNAaW50ZWwuY29tPg0KLS0tDQogZGFw
bC9jb21tb24vZGFwbF9lcF9tb2RpZnkuYyB8ICAgIDYgKysrKysrDQogMSBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kYXBsL2Nv
bW1vbi9kYXBsX2VwX21vZGlmeS5jIGIvZGFwbC9jb21tb24vZGFwbF9lcF9tb2RpZnkuYw0KaW5k
ZXggOWYwMDk1Zi4uMDU0NTg3MCAxMDA2NDQNCi0tLSBhL2RhcGwvY29tbW9uL2RhcGxfZXBfbW9k
aWZ5LmMNCisrKyBiL2RhcGwvY29tbW9uL2RhcGxfZXBfbW9kaWZ5LmMNCkBAIC0zODUsNiArMzg1
LDEyIEBAIGRhcGxpX2VwX21vZGlmeV92YWxpZGF0ZV9wYXJhbWV0ZXJzKElOIERBVF9FUF9IQU5E
TEUgZXBfaGFuZGxlLA0KIAkJZ290byBiYWlsOw0KIAl9DQogDQorCWlmIChlcF9wYXJhbSA9PSBO
VUxMKSB7DQorCQlkYXRfc3RhdHVzID0NCisJCSAgICBEQVRfRVJST1IoREFUX0lOVkFMSURfUEFS
QU1FVEVSLCBEQVRfSU5WQUxJRF9BUkczKTsNCisJCWdvdG8gYmFpbDsNCisJfQ0KKw0KIAllcCA9
IChEQVBMX0VQICopIGVwX2hhbmRsZTsNCiAJaWEgPSBlcC0+aGVhZGVyLm93bmVyX2lhOw0KIA0K
LS0gDQoxLjcuMw0KDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
