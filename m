From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/13] DAPL v2.0: dat: add check for NULL handle on IA calls
Date: Fri, 13 Jan 2012 23:55:40 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F92AF829CB@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Y2hlY2sgYWRkZWQgdG8gZGF0c19nZXRfaWFfaGFuZGxlKCkNCg0KU2lnbmVkLW9mZi1ieTogQXJs
aW4gRGF2aXMgPGFybGluLnIuZGF2aXNAaW50ZWwuY29tPg0KLS0tDQogZGF0L2NvbW1vbi9kYXRf
YXBpLmMgfCAgICAzICsrKw0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAwIGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZGF0L2NvbW1vbi9kYXRfYXBpLmMgYi9kYXQvY29t
bW9uL2RhdF9hcGkuYw0KaW5kZXggNGU2ZWFkZC4uZjUzZWFkNyAxMDA3NTUNCi0tLSBhL2RhdC9j
b21tb24vZGF0X2FwaS5jDQorKysgYi9kYXQvY29tbW9uL2RhdF9hcGkuYw0KQEAgLTE3OCw2ICsx
NzgsOSBAQCBkYXRzX2dldF9pYV9oYW5kbGUoSU4gREFUX0lBX0hBTkRMRSBoYW5kbGUsIE9VVCBE
QVRfSUFfSEFORExFICogaWFfaGFuZGxlX3ApDQogew0KIAlEQVRfUkVUVVJOIGRhdF9zdGF0dXMg
PSBEQVRfU1VDQ0VTUzsNCiANCisJaWYgKGhhbmRsZSA9PSBOVUxMKQ0KKwkJcmV0dXJuIERBVF9F
UlJPUihEQVRfSU5WQUxJRF9IQU5ETEUsIERBVF9JTlZBTElEX0hBTkRMRV9JQSk7DQorDQogCS8q
IGhhbmRsZSB0byB2ZWN0b3IgKi8NCiAJaWYgKERBVF9JQV9IQU5ETEVfVE9fVUwoaGFuZGxlKSA+
PSBnX2h2LmhhbmRsZV9tYXgpIHsNCiAJCXVuc2lnbmVkIGxvbmcgaTsNCi0tIA0KMS43LjMNCg0K
DQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
