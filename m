From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: scm: add port number to error log during
 hca_open failures
Date: Wed, 26 Oct 2011 21:10:03 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E88583@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

c2NtOiBhZGQgcG9ydCBudW1iZXIgdG8gZXJyb3IgbG9nIGR1cmluZyBoY2Ffb3BlbiBmYWlsdXJl
cw0KDQpTaWduZWQtb2ZmLWJ5OiBBcmxpbiBEYXZpcyA8YXJsaW4uci5kYXZpc0BpbnRlbC5jb20+
DQotLS0NCiBkYXBsL29wZW5pYl9zY20vZGV2aWNlLmMgfCAgICAzICsrLQ0KIDEgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZGFw
bC9vcGVuaWJfc2NtL2RldmljZS5jIGIvZGFwbC9vcGVuaWJfc2NtL2RldmljZS5jDQppbmRleCA0
MWZjY2RmLi43N2M2NGUzIDEwMDY0NA0KLS0tIGEvZGFwbC9vcGVuaWJfc2NtL2RldmljZS5jDQor
KysgYi9kYXBsL29wZW5pYl9zY20vZGV2aWNlLmMNCkBAIC0zMjQsOCArMzI0LDkgQEAgZm91bmQ6
DQogCWlmIChpYnZfcXVlcnlfcG9ydChoY2FfcHRyLT5pYl9oY2FfaGFuZGxlLA0KIAkJCSAgICh1
aW50OF90KSBoY2FfcHRyLT5wb3J0X251bSwgJnBvcnRfYXR0cikpIHsNCiAJCWRhcGxfbG9nKERB
UExfREJHX1RZUEVfRVJSLA0KLQkJCSAiIG9wZW5faGNhOiBnZXQgbGlkIEVSUiBmb3IgJXMsIGVy
cj0lc1xuIiwNCisJCQkgIiBvcGVuX2hjYTogZ2V0IGxpZCBFUlIgZm9yICVzIHBvcnQ9JWQsIGVy
cj0lc1xuIiwNCiAJCQkgaWJ2X2dldF9kZXZpY2VfbmFtZShoY2FfcHRyLT5pYl90cmFucy5pYl9k
ZXYpLA0KKwkJCSBoY2FfcHRyLT5wb3J0X251bSwNCiAJCQkgc3RyZXJyb3IoZXJybm8pKTsNCiAJ
CWdvdG8gZXJyOw0KIAl9IGVsc2Ugew0KLS0gDQoxLjcuMw0KDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
