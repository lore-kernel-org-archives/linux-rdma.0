From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion
 queue pools
Date: Thu, 9 Nov 2017 17:33:35 +0000
Message-ID: <1510248814.2608.19.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <20171108095742.25365-2-sagi@grimberg.me>
         <fe2c23b7-2923-2693-28c3-6a6f399bda26@mellanox.com>
         <23b598f2-6982-0d15-69e4-c526c627ec33@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23b598f2-6982-0d15-69e4-c526c627ec33-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <F31E6FD710F68C4E82ED881EDF0C9E63-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTA5IGF0IDE5OjMxICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiA+ID4gK3N0YXRpYyBpbnQgaWJfYWxsb2NfY3FzKHN0cnVjdCBpYl9kZXZpY2UgKmRldiwgaW50
IG5yX2NxZXMsDQo+ID4gPiArICAgICAgICBlbnVtIGliX3BvbGxfY29udGV4dCBwb2xsX2N0eCkN
Cj4gPiA+ICt7DQo+ID4gPiArICAgIExJU1RfSEVBRCh0bXBfbGlzdCk7DQo+ID4gPiArICAgIHN0
cnVjdCBpYl9jcSAqY3E7DQo+ID4gPiArICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gPiAr
ICAgIGludCBucl9jcXMsIHJldCwgaTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgLyoNCj4gPiA+ICsg
ICAgICogQWxsb2NhdGVkIGF0IGxlYXN0IGFzIG1hbnkgQ1FFcyBhcyByZXF1ZXN0ZWQsIGFuZCBv
dGhlcndpc2UNCj4gPiA+ICsgICAgICogYSByZWFzb25hYmxlIGJhdGNoIHNpemUgc28gdGhhdCB3
ZSBjYW4gc2hhcmUgQ1FzIGJldHdlZW4NCj4gPiA+ICsgICAgICogbXVsdGlwbGUgdXNlcnMgaW5z
dGVhZCBvZiBhbGxvY2F0aW5nIGEgbGFyZ2VyIG51bWJlciBvZiBDUXMuDQo+ID4gPiArICAgICAq
Lw0KPiA+ID4gKyAgICBucl9jcWVzID0gbWF4KG5yX2NxZXMsIG1pbihkZXYtPmF0dHJzLm1heF9j
cWUsIElCX0NRRV9CQVRDSCkpOw0KPiA+IA0KPiA+IGRpZCB5b3UgbWVhbiBtaW4oKSA/DQo+IA0K
PiBObywgSSBtZWFudCBtYXguIElmIHdlIGNob29zZSB0aGUgQ1Egc2l6ZSwgd2UgY2hvb3NlIHRo
ZSBtaW4gYmV0d2VlbiB0aGUNCj4gZGVmYXVsdCBhbmQgdGhlIGRldmljZSBjYXBhYmlsaXR5LCBp
ZiB0aGUgdXNlciBjaG9vc2VzLCB3ZSByZWx5IHRoYXQgaXQNCj4gYXNrZWQgZm9yIG5vIG1vcmUg
dGhhbiB0aGUgZGV2aWNlIGNhcGFiaWxpdHkgKGFuZCBpZiBub3QsIGFsbG9jYXRpb24NCj4gd2ls
bCBmYWlsLCBhcyBpdCBzaG91bGQpLg0KDQpIZWxsbyBTYWdpLA0KDQpIb3cgYWJvdXQgdGhlIGZv
bGxvd2luZzoNCg0KCW1pbihkZXYtPmF0dHJzLm1heF9jcWUsIG1heChucl9jcWVzLCBJQl9DUUVf
QkFUQ0gpKQ0KDQpCYXJ0Lg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
