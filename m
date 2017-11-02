From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Remove unneeded condition
Date: Thu, 2 Nov 2017 15:10:27 +0000
Message-ID: <1509635426.2484.9.camel@wdc.com>
References: <20171102135134.5728-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102135134.5728-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <1A302A6E63398E408BBB032410611233-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTAyIGF0IDE1OjUxICswMjAwLCBZdXZhbCBTaGFpYSB3cm90ZToNCj4g
VGhlIGNoZWNrIG1ha2VzIG5vIGRpZmZlcmVuY2UgLSByZW1vdmUgaXQuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBZdXZhbCBTaGFpYSA8eXV2YWwuc2hhaWFAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICBs
aWJyZG1hY20vY21hLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbGlicmRtYWNtL2NtYS5jIGIv
bGlicmRtYWNtL2NtYS5jDQo+IGluZGV4IDdhYWY0NWYyLi42ZWViZTcxYiAxMDA2NDQNCj4gLS0t
IGEvbGlicmRtYWNtL2NtYS5jDQo+ICsrKyBiL2xpYnJkbWFjbS9jbWEuYw0KPiBAQCAtODgwLDgg
Kzg4MCw4IEBAIHN0YXRpYyBpbnQgcmRtYV9yZXNvbHZlX2FkZHIyKHN0cnVjdCByZG1hX2NtX2lk
ICppZCwgc3RydWN0IHNvY2thZGRyICpzcmNfYWRkciwNCj4gIAlDTUFfSU5JVF9DTUQoJmNtZCwg
c2l6ZW9mIGNtZCwgUkVTT0xWRV9BRERSKTsNCj4gIAlpZF9wcml2ID0gY29udGFpbmVyX29mKGlk
LCBzdHJ1Y3QgY21hX2lkX3ByaXZhdGUsIGlkKTsNCj4gIAljbWQuaWQgPSBpZF9wcml2LT5oYW5k
bGU7DQo+IC0JaWYgKChjbWQuc3JjX3NpemUgPSBzcmNfbGVuKSkNCj4gLQkJbWVtY3B5KCZjbWQu
c3JjX2FkZHIsIHNyY19hZGRyLCBzcmNfbGVuKTsNCj4gKwljbWQuc3JjX3NpemUgPSBzcmNfbGVu
Ow0KPiArCW1lbWNweSgmY21kLnNyY19hZGRyLCBzcmNfYWRkciwgc3JjX2xlbik7DQo+ICAJbWVt
Y3B5KCZjbWQuZHN0X2FkZHIsIGRzdF9hZGRyLCBkc3RfbGVuKTsNCj4gIAljbWQuZHN0X3NpemUg
PSBkc3RfbGVuOw0KPiAgCWNtZC50aW1lb3V0X21zID0gdGltZW91dF9tczsNCg0KU2hvdWxkbid0
IHRoZSBkZXNjcmlwdGlvbiBoYXZlIGJlZW4gIlBhc3NpbmcgemVybyBhcyB0aGlyZCBhcmd1bWVu
dCB0bw0KbWVtY3B5KCkgaXMgYWxsb3dlZCBzbyB0aGUgaWYtdGVzdCBpcyBub3QgbmVjZXNzYXJ5
LiBIZW5jZSBsZWF2ZSBpdCBvdXQiPw0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
