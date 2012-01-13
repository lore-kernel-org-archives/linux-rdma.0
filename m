From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/13] DAPL v2.0: common: cleanup debug message on EVD
 overflows
Date: Fri, 13 Jan 2012 23:55:04 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F92AF8197F@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

U2lnbmVkLW9mZi1ieTogQXJsaW4gRGF2aXMgPGFybGluLnIuZGF2aXNAaW50ZWwuY29tPg0KLS0t
DQogZGFwbC9jb21tb24vZGFwbF9ldmRfdXRpbC5jIHwgICAgMiArLQ0KIDEgZmlsZXMgY2hhbmdl
ZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZGFwbC9j
b21tb24vZGFwbF9ldmRfdXRpbC5jIGIvZGFwbC9jb21tb24vZGFwbF9ldmRfdXRpbC5jDQppbmRl
eCA0MTQyM2IyLi5hN2I4YzU0IDEwMDY0NA0KLS0tIGEvZGFwbC9jb21tb24vZGFwbF9ldmRfdXRp
bC5jDQorKysgYi9kYXBsL2NvbW1vbi9kYXBsX2V2ZF91dGlsLmMNCkBAIC02NTYsNyArNjU2LDcg
QEAgZGFwbHNfZXZkX3Bvc3Rfb3ZlcmZsb3dfZXZlbnQoSU4gREFQTF9FVkQgKiBldmRfcHRyKQ0K
IAlEQVBMX0VWRCAqYXN5bmNfZXZkX3B0ciA9IGV2ZF9wdHItPmhlYWRlci5vd25lcl9pYS0+YXN5
bmNfZXJyb3JfZXZkOw0KIAlEQVRfRVZFTlQgKmV2ZW50X3B0cjsNCiANCi0JZGFwbF9sb2coREFQ
TF9EQkdfVFlQRV9XQVJOLCAiIFdBUk5JTkc6IG92ZXJmbG93IGV2ZW50IG9uIEVWRCAlcC9uIiwg
ZXZkX3B0cik7DQorCWRhcGxfbG9nKERBUExfREJHX1RZUEVfV0FSTiwgIiBXQVJOSU5HOiBvdmVy
ZmxvdyBldmVudCBvbiBFVkQgJXBcbiIsIGV2ZF9wdHIpOw0KIA0KIAlkYXBsX29zX2xvY2soJmFz
eW5jX2V2ZF9wdHItPmhlYWRlci5sb2NrKTsNCiANCi0tIA0KMS43LjMNCg0KDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
