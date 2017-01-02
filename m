From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/15] IB/rxe: Add a runtime check in alloc_index()
Date: Mon, 2 Jan 2017 10:41:58 +0000
Message-ID: <1483353638.3592.30.camel@sandisk.com>
References: <1483353316.3592.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353316.3592.14.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <FEC9408D61403E4E8CE7523BBAC4265B-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

U2luY2UgaW5kZXggdmFsdWVzIGVxdWFsIHRvIG9yIGFib3ZlICdyYW5nZScgY2FuIHRyaWdnZXIg
bWVtb3J5DQpjb3JydXB0aW9uLCBjb21wbGFpbiBpZiBpbmRleCA+PSByYW5nZS4NCg0KU2lnbmVk
LW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCkNj
OiBNb25pIFNob3VhIDxtb25pc0BtZWxsYW5veC5jb20+DQpDYzogQW5kcmV3IEJveWVyIDxhbmRy
ZXcuYm95ZXJAZGVsbC5jb20+DQotLS0NCsKgZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9yeGVf
cG9vbC5jIHwgMSArDQrCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9yeGVfcG9vbC5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL3N3L3J4ZS9yeGVfcG9vbC5jDQppbmRleCA3ZDFlMjg2MmI5MjguLjc1ZDExZWU2MzVl
YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3Bvb2wuYw0KKysr
IGIvZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZS9yeGVfcG9vbC5jDQpAQCAtMjY2LDYgKzI2Niw3
IEBAIHN0YXRpYyB1MzIgYWxsb2NfaW5kZXgoc3RydWN0IHJ4ZV9wb29sICpwb29sKQ0KwqAJaWYg
KGluZGV4ID49IHJhbmdlKQ0KwqAJCWluZGV4ID0gZmluZF9maXJzdF96ZXJvX2JpdChwb29sLT50
YWJsZSwgcmFuZ2UpOw0KwqANCisJV0FSTl9PTl9PTkNFKGluZGV4ID49IHJhbmdlKTsNCsKgCXNl
dF9iaXQoaW5kZXgsIHBvb2wtPnRhYmxlKTsNCsKgCXBvb2wtPmxhc3QgPSBpbmRleDsNCsKgCXJl
dHVybiBpbmRleCArIHBvb2wtPm1pbl9pbmRleDsNCi0twqANCjIuMTEuMA0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
