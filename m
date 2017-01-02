From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 05/15] IB/rxe: Remove superfluous casts
Date: Mon, 2 Jan 2017 10:40:30 +0000
Message-ID: <1483353522.3592.22.camel@sandisk.com>
References: <1483353316.3592.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353316.3592.14.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <4C7ACAC2530EC845A384691A9ED8EE3E-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Q2FzdGluZyBhIHBvaW50ZXIgdG8gJ3ZvaWQgKicgZXhwbGljaXRseSBpcyBub3QgbmVjZXNzYXJ5
IGluIEMgY29kZS4NCg0KU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFz
c2NoZUBzYW5kaXNrLmNvbT4NCkNjOiBNb25pIFNob3VhIDxtb25pc0BtZWxsYW5veC5jb20+DQpD
YzogQW5kcmV3IEJveWVyIDxhbmRyZXcuYm95ZXJAZGVsbC5jb20+DQotLS0NCsKgZHJpdmVycy9p
bmZpbmliYW5kL3N3L3J4ZS9yeGVfcG9vbC5jIHwgNCArKy0tDQrCoDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lu
ZmluaWJhbmQvc3cvcnhlL3J4ZV9wb29sLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4
ZV9wb29sLmMNCmluZGV4IDRmZTExMTQ4YjMwNC4uN2QxZTI4NjJiOTI4IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9yeGVfcG9vbC5jDQorKysgYi9kcml2ZXJzL2luZmlu
aWJhbmQvc3cvcnhlL3J4ZV9wb29sLmMNCkBAIC00NTQsNyArNDU0LDcgQEAgdm9pZCAqcnhlX3Bv
b2xfZ2V0X2luZGV4KHN0cnVjdCByeGVfcG9vbCAqcG9vbCwgdTMyIGluZGV4KQ0KwqANCsKgb3V0
Og0KwqAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG9vbC0+cG9vbF9sb2NrLCBmbGFncyk7DQot
CXJldHVybiBub2RlID8gKHZvaWQgKillbGVtIDogTlVMTDsNCisJcmV0dXJuIG5vZGUgPyBlbGVt
IDogTlVMTDsNCsKgfQ0KwqANCsKgdm9pZCAqcnhlX3Bvb2xfZ2V0X2tleShzdHJ1Y3QgcnhlX3Bv
b2wgKnBvb2wsIHZvaWQgKmtleSkNCkBAIC00OTAsNSArNDkwLDUgQEAgdm9pZCAqcnhlX3Bvb2xf
Z2V0X2tleShzdHJ1Y3QgcnhlX3Bvb2wgKnBvb2wsIHZvaWQgKmtleSkNCsKgDQrCoG91dDoNCsKg
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBvb2wtPnBvb2xfbG9jaywgZmxhZ3MpOw0KLQlyZXR1
cm4gbm9kZSA/ICgodm9pZCAqKWVsZW0pIDogTlVMTDsNCisJcmV0dXJuIG5vZGUgPyBlbGVtIDog
TlVMTDsNCsKgfQ0KLS3CoA0KMi4xMS4wDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
