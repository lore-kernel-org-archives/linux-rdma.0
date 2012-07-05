From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] ucm: record and silently drop a duplicate reject CM
 message
Date: Thu, 5 Jul 2012 16:38:18 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481A87DD@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

U2lnbmVkLW9mZi1ieTogQXJsaW4gRGF2aXMgPGFybGluLnIuZGF2aXNAaW50ZWwuY29tPg0KLS0t
DQogZGFwbC9vcGVuaWJfdWNtL2NtLmMgfCAgICA2ICsrKysrKw0KIDEgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZGFwbC9vcGVu
aWJfdWNtL2NtLmMgYi9kYXBsL29wZW5pYl91Y20vY20uYw0KaW5kZXggMzU3ZGJmNy4uNGU2YzUy
NyAxMDA2NDQNCi0tLSBhL2RhcGwvb3BlbmliX3VjbS9jbS5jDQorKysgYi9kYXBsL29wZW5pYl91
Y20vY20uYw0KQEAgLTQxNSw2ICs0MTUsMTIgQEAgc3RhdGljIHZvaWQgdWNtX3Byb2Nlc3NfcmVj
dihpYl9oY2FfdHJhbnNwb3J0X3QgKnRwLA0KIAkJfQ0KIAkJZGFwbF9vc191bmxvY2soJmNtLT5s
b2NrKTsNCiAJCWJyZWFrOw0KKwljYXNlIERDTV9SRUpFQ1RFRDoNCisJCWlmIChudG9ocyhtc2ct
Pm9wKSA9PSBEQ01fUkVKX1VTRVIpIHsNCisJCQlEQVBMX0NOVFIoKChEQVBMX0lBICopZGFwbF9s
bGlzdF9wZWVrX2hlYWQoJmNtLT5oY2EtPmlhX2xpc3RfaGVhZCkpLCBEQ05UX0lBX0NNX1VTRVJf
UkVKX1JYKTsNCisJCQlkYXBsX29zX3VubG9jaygmY20tPmxvY2spOw0KKwkJCWJyZWFrOw0KKwkJ
fQ0KIAlkZWZhdWx0Og0KIAkJZGFwbF9sb2coREFQTF9EQkdfVFlQRV9XQVJOLA0KIAkJCSIgdWNt
X3JlY3Y6IFdhcm5pbmcsIFVOS05PV04gc3RhdGUiDQotLSANCjEuNy4zDQoNCg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
