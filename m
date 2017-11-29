From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Wed, 29 Nov 2017 05:55:38 +0000
Message-ID: <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3676820c-544e-8ced-859a-ade8e6a0ef53-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgU2FnaSwNCg0KPiA+IFJlcG9ydGVkLWJ5OiBBbXJhbmksIFJhbSA8UmFtLkFtcmFuaUBjYXZp
dW0uY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcu
bWU+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2luZmluaWJhbmQvdWxwL2lzZXJ0L2liX2lzZXJ0
LmMgfCAxICsNCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNlcnQvaWJfaXNlcnQuYyBiL2Ry
aXZlcnMvaW5maW5pYmFuZC91bHAvaXNlcnQvaWJfaXNlcnQuYw0KPiA+IGluZGV4IGNlYWJkYjg1
ZGY4Yi4uOWQ0Nzg1YmEyNGNiIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91
bHAvaXNlcnQvaWJfaXNlcnQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXNl
cnQvaWJfaXNlcnQuYw0KPiA+IEBAIC03NDEsNiArNzQxLDcgQEAgaXNlcnRfY29ubmVjdF9lcnJv
cihzdHJ1Y3QgcmRtYV9jbV9pZCAqY21hX2lkKQ0KPiA+ICAgew0KPiA+ICAgCXN0cnVjdCBpc2Vy
dF9jb25uICppc2VydF9jb25uID0gY21hX2lkLT5xcC0+cXBfY29udGV4dDsNCj4gPg0KPiA+ICsJ
aWJfZHJhaW5fcXAoaXNlcnRfY29ubi0+cXApOw0KPiA+ICAgCWxpc3RfZGVsX2luaXQoJmlzZXJ0
X2Nvbm4tPm5vZGUpOw0KPiA+ICAgCWlzZXJ0X2Nvbm4tPmNtX2lkID0gTlVMTDsNCj4gPiAgIAlp
c2VydF9wdXRfY29ubihpc2VydF9jb25uKTsNCj4gPg0KPiAtLQ0KDQpJZiBpdCdzIG5vdCBhbHJl
YWR5IGNvbW1pdHRlZCwgY2FuIHlvdSBhZGQgYSAiRml4ZXM6IiBzbyBzdGFibGUgbWFpbnRhaW5l
cnMgd2lsbCBjYXRjaCBpdD8NCg0KVGhhbmtzLA0KUmFtDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
