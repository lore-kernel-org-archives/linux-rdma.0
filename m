From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/qib: Use memdup_user() rather than duplicating its
 implementation
Date: Fri, 19 Aug 2016 15:27:20 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2D0AF815@fmsmsx120.amr.corp.intel.com>
References: <620b3961-6e05-6638-4ca8-18766acc91f4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <620b3961-6e05-6638-4ca8-18766acc91f4-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0hdIElCL3FpYjogVXNlIG1lbWR1cF91c2VyKCkgcmF0aGVyIHRoYW4g
ZHVwbGljYXRpbmcgaXRzDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWli
L3FpYl9mcy5jDQoNCkkgd291bGQgYmUgZXZlbiBtb3JlIGFnZ3Jlc3NpdmUgYXQgcmVkdWNpbmcg
bGluZXMgb2YgY29kZS4NCg0KRm9yIGV4YW1wbGUgZG8gZGlyZWN0IHJldHVybnMgd2hlbiBvayB0
byBkbzoNCiAgICAgICAgaWYgKHBvcyAhPSAwIHx8IGNvdW50ICE9IHNpemVvZihzdHJ1Y3QgcWli
X2ZsYXNoKSkNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCg0KICAgICAgICB0bXAg
PSBtZW1kdXBfdXNlcihidWYsIGNvdW50KTsNCiAgICAgICAgaWYgKElTX0VSUih0bXApKQ0KICAg
ICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKHRtcCk7DQoNClRoZSBiYWlsX3RtcDogbGFiZWwg
aXMgdGhlbiBub3QgbmVlZGVkLg0KDQpNaWtlDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
