From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 2/4] nvmet-rdma: notify QP on Last WQE Reached event
 arrival
Date: Thu, 18 Jan 2018 18:04:25 +0000
Message-ID: <1516298665.2676.27.camel@wdc.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
         <1516197178-26493-3-git-send-email-maxg@mellanox.com>
         <02bf01d38fa9$05254550$0f6fcff0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02bf01d38fa9$05254550$0f6fcff0$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <8F4454FEFA20F24D81BBAE2ED9AEAC12-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTE3IGF0IDA5OjM3IC0wNjAwLCBTdGV2ZSBXaXNlIHdyb3RlOg0KPiA+
IA0KPiA+IEluIG9yZGVyIHRvIGF2b2lkIHJlc291cmNlIGxlYWthZ2UgZm9yIFFQIGFzc29jaWF0
ZWQgd2l0aA0KPiA+IGEgU2hhcmVkIFJlY2VpdmUgUXVldWUgKFNSUSksIG5vdGlmeSBpdCBvbiBM
YXN0IFdRRSBSZWFjaGVkDQo+ID4gZXZlbnQgYXJyaXZhbC4NCj4gPiANCj4gPiBTaWduZWQtb2Zm
LWJ5OiBNYXggR3VydG92b3kgPG1heGdAbWVsbGFub3guY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2
ZXJzL252bWUvdGFyZ2V0L3JkbWEuYyB8IDMgKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL3RhcmdldC9y
ZG1hLmMgYi9kcml2ZXJzL252bWUvdGFyZ2V0L3JkbWEuYw0KPiA+IGluZGV4IDQ5OTEyOTAuLjk5
YTE0YTcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9udm1lL3RhcmdldC9yZG1hLmMNCj4gPiAr
KysgYi9kcml2ZXJzL252bWUvdGFyZ2V0L3JkbWEuYw0KPiA+IEBAIC0xMTUxLDYgKzExNTEsOSBA
QCBzdGF0aWMgdm9pZCBudm1ldF9yZG1hX3FwX2V2ZW50KHN0cnVjdCBpYl9ldmVudA0KPiA+ICpl
dmVudCwgdm9pZCAqcHJpdikNCj4gPiAgCWNhc2UgSUJfRVZFTlRfQ09NTV9FU1Q6DQo+ID4gIAkJ
cmRtYV9ub3RpZnkocXVldWUtPmNtX2lkLCBldmVudC0+ZXZlbnQpOw0KPiA+ICAJCWJyZWFrOw0K
PiA+ICsJY2FzZSBJQl9FVkVOVF9RUF9MQVNUX1dRRV9SRUFDSEVEOg0KPiA+ICsJCWliX25vdGlm
eV9xcChxdWV1ZS0+Y21faWQtPnFwLCBldmVudC0+ZXZlbnQpOw0KPiA+ICsJCWJyZWFrOw0KPiA+
ICAJZGVmYXVsdDoNCj4gPiAgCQlwcl9lcnIoInJlY2VpdmVkIElCIFFQIGV2ZW50OiAlcyAoJWQp
XG4iLA0KPiA+ICAJCSAgICAgICBpYl9ldmVudF9tc2coZXZlbnQtPmV2ZW50KSwgZXZlbnQtPmV2
ZW50KTsNCj4gDQo+IEkgd29uZGVyIGlmIHRoaXMgY291bGQgYmUgaGFuZGxlZCBpbiBpYl9kaXNw
YXRjaF9ldmVudCgpIGZvciBhbGwgVUxQUz8NCg0KQXMgZmFyIGFzIEkgY2FuIHNlZSBhbGwgaWJf
ZGlzcGF0Y2hfZXZlbnQoKSBjYWxscyBmb3IgSUJfRVZFTlRfUVBfTEFTVF9XUUVfUkVBQ0hFRA0K
c2V0IGVsZW1lbnQucXAgaW4gc3RydWN0IGliX2V2ZW50LiBTbyBJJ2QgYWxzbyBsaWtlIHRvIHNl
ZSB0aGlzIHByb3Bvc2FsIHRvIGJlIA0KZXhwbG9yZWQgZnVydGhlci4NCg0KVGhhbmtzLA0KDQpC
YXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
