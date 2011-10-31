From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: dat: dat_cno_query with NULL cno_handle causes
 segmentation fault
Date: Mon, 31 Oct 2011 20:53:52 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E918C1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

YWRkIGNoZWNrIGZvciBOVUxMIGhhbmRsZSBpbiBkYXQgbGlicmFyeQ0KDQpTaWduZWQtb2ZmLWJ5
OiBBcmxpbiBEYXZpcyA8YXJsaW4uci5kYXZpc0BpbnRlbC5jb20+DQotLS0NCiBkYXQvdWRhdC91
ZGF0X2FwaS5jIHwgICAgMyArKysNCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RhdC91ZGF0L3VkYXRfYXBpLmMgYi9kYXQv
dWRhdC91ZGF0X2FwaS5jDQppbmRleCA1OTQ4YTRmLi42YzE1NDlhIDEwMDY0NA0KLS0tIGEvZGF0
L3VkYXQvdWRhdF9hcGkuYw0KKysrIGIvZGF0L3VkYXQvdWRhdF9hcGkuYw0KQEAgLTE2MSw2ICsx
NjEsOSBAQCBEQVRfUkVUVVJOIERBVF9BUEkgZGF0X2Nub19xdWVyeShJTiBEQVRfQ05PX0hBTkRM
RSBjbm9faGFuZGxlLA0KIAkJCQkgSU4gREFUX0NOT19QQVJBTV9NQVNLIGNub19wYXJhbV9tYXNr
LA0KIAkJCQkgT1VUIERBVF9DTk9fUEFSQU0gKiBjbm9fcGFyYW0pDQogew0KKwlpZiAoY25vX2hh
bmRsZSA9PSBOVUxMKSB7DQorCQlyZXR1cm4gREFUX0VSUk9SKERBVF9JTlZBTElEX0hBTkRMRSwg
REFUX0lOVkFMSURfSEFORExFX0NOTyk7DQorCX0NCiAJcmV0dXJuIERBVF9DTk9fUVVFUlkoY25v
X2hhbmRsZSwgY25vX3BhcmFtX21hc2ssIGNub19wYXJhbSk7DQogfQ0KIA0KLS0gDQoxLjcuMw0K
DQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
