From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
Date: Thu, 24 Aug 2017 09:54:56 +0000
Message-ID: <BN3PR07MB25783DB2F45A5AD7D3B6CB15F89A0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20170824082553.18619-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824082553.18619-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4g
VHJpdmlhbCBmaXggdG8gc3BlbGxpbmcgbWlzdGFrZSBpbiBEUF9FUlIgZXJyb3IgbWVzc2FnZQ0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2Fs
LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvcWVkci92ZXJicy5jIHwgMiAr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FlZHIvdmVyYnMuYyBiL2RyaXZl
cnMvaW5maW5pYmFuZC9ody9xZWRyL3ZlcmJzLmMNCj4gaW5kZXggNGUxNGE1NTg3MzRiLi45NjEy
YWFhOWZiYmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyL3ZlcmJz
LmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FlZHIvdmVyYnMuYw0KPiBAQCAtNTEw
LDcgKzUxMCw3IEBAIHN0cnVjdCBpYl9wZCAqcWVkcl9hbGxvY19wZChzdHJ1Y3QgaWJfZGV2aWNl
ICppYmRldiwNCj4gIAkJICh1ZGF0YSAmJiBjb250ZXh0KSA/ICJVc2VyIExpYiIgOiAiS2VybmVs
Iik7DQo+IA0KPiAgCWlmICghZGV2LT5yZG1hX2N0eCkgew0KPiAtCQlEUF9FUlIoZGV2LCAiaW52
bGFpZCBSRE1BIGNvbnRleHRcbiIpOw0KPiArCQlEUF9FUlIoZGV2LCAiaW52YWxpZCBSRE1BIGNv
bnRleHRcbiIpOw0KPiAgCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gIAl9DQo+IA0KPiAt
LQ0KPiAyLjE0LjENCg0KDQpUaGFua3MsDQoNClJldmlld2VkLWJ5OiBSYW0gQW1yYW5pIDxSYW0u
QW1yYW5pQGNhdml1bS5jb20+DQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
