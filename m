From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] qedr: return -EINVAL if pd is null and avoid null ptr
 dereference
Date: Thu, 20 Oct 2016 07:12:05 +0000
Message-ID: <SN1PR07MB22076D4325D51DDB3C66E1E8F8D50@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <20161018183928.8539-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018183928.8539-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L3FlZHIvdmVyYnMuYyB8IDQgKysrLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyL3ZlcmJzLmMNCj4gYi9kcml2ZXJzL2luZmlu
aWJhbmQvaHcvcWVkci92ZXJicy5jDQo+IGluZGV4IGE2MTUxNDIuLmIyYTBlYjggMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyL3ZlcmJzLmMNCj4gKysrIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2h3L3FlZHIvdmVyYnMuYw0KPiBAQCAtNTExLDggKzUxMSwxMCBAQCBpbnQg
cWVkcl9kZWFsbG9jX3BkKHN0cnVjdCBpYl9wZCAqaWJwZCkNCj4gIAlzdHJ1Y3QgcWVkcl9kZXYg
KmRldiA9IGdldF9xZWRyX2RldihpYnBkLT5kZXZpY2UpOw0KPiAgCXN0cnVjdCBxZWRyX3BkICpw
ZCA9IGdldF9xZWRyX3BkKGlicGQpOw0KPiANCj4gLQlpZiAoIXBkKQ0KPiArCWlmICghcGQpIHsN
Cj4gIAkJcHJfZXJyKCJJbnZhbGlkIFBEIHJlY2VpdmVkIGluIGRlYWxsb2NfcGRcbiIpOw0KPiAr
CQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+IA0KPiAgCURQX0RFQlVHKGRldiwgUUVEUl9NU0df
SU5JVCwgIkRlYWxsb2NhdGluZyBQRCAlZFxuIiwgcGQtPnBkX2lkKTsNCj4gIAlkZXYtPm9wcy0+
cmRtYV9kZWFsbG9jX3BkKGRldi0+cmRtYV9jdHgsIHBkLT5wZF9pZCk7DQo+IC0tDQo+IDIuOS4z
DQoNClRoYW5rcyBDb2xpbi4NCg0KQWNrZWQtYnk6IFJhbSBBbXJhbmkgPHJhbS5hbXJhbmlAY2F2
aXVtLmNvbT4NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
