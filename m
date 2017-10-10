From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
 to use
Date: Tue, 10 Oct 2017 15:08:03 +0000
Message-ID: <1507648081.2815.5.camel@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
         <20171006213333.6721-41-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC3442AAD2@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3442AAD2-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <B39B051B887020419DC4614CB53D15E6-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTEwIGF0IDE0OjE1ICswMDAwLCBNYXJjaW5pc3p5biwgTWlrZSB3cm90
ZToNCj4gPiBTdWJqZWN0OiBbUEFUQ0ggNDAvNDddIElCL3FpYjogTWFrZSBxaWJfaW5jX2VlcHJv
bV9lcnIoKSBtYWNybyBtb3JlIHNhZmUNCj4gPiB0byB1c2UNCj4gPiANCj4gPiBBdm9pZCB0aGF0
IHVzaW5nIHRoZSBxaWJfaW5jX2VlcHJvbV9lcnIoKSBtYWNybyBpbiBhbiBpZi1zdGF0ZW1lbnQN
Cj4gPiB0cmlnZ2VycyB0aGUgZm9sbG93aW5nIGNvbXBpbGVyIHdhcm5pbmc6DQo+ID4gDQo+ID4g
d2FybmluZzogc3VnZ2VzdCBicmFjZXMgYXJvdW5kIGVtcHR5IGJvZHkgaW4gYW4gJ2lmJyBzdGF0
ZW1lbnQgWy1XZW1wdHktDQo+ID4gYm9keV0NCj4gPiANCj4gDQo+IFRoZXJlIG5lZWRzIHRvIGJl
IGEgZm9sbG93LW9uIHBhdGNoIGhlcmUgdG8gZ2V0IHJpZCBvZiB0aGUgdXNlcyBvZiB0aGlzIG1h
Y3JvLg0KPiANCj4gVGhlIG9yaWdpbmFsIGZpeCBnb3QgcmlkIG9mIGEgYmFkIGltcGxlbWVudGF0
aW9uLCBidXQgc2hvdWxkIGhhdmUgdG90YWxseQ0KPiByZW1vdmVkIGJvdGggdGhlIGZ1bmN0aW9u
IGFuZCBpdHMgdXNlLg0KPiANCj4gVGhlIGlzIG5vdCB0aGUgZmF1bHQgb2YgdGhpcyBwYXRjaC4N
Cj4gDQo+IEZpeGVzOiAxOGMwYjgyYTNlNDUgICgiIElCL3FpYjogRG8gbm90IHdyaXRlIEVFUFJP
TSIpDQo+IEFja2VkLWJ5OiBNaWtlIE1hcmNpbmlzenluIDxtaWtlLm1hcmNpbmlzenluQGludGVs
LmNvbT4NCg0KSGVsbG8gTWlrZSwNCg0KSG93IGFib3V0IGRyb3BwaW5nIHRoaXMgcGF0Y2ggYW5k
IHJlcGxhY2luZyBpdCB3aXRoIGEgcGF0Y2ggdGhhdCByZW1vdmVzIGFsbCB1c2VzDQpvZiBxaWJf
aW5jX2VlcHJvbV9lcnIoKT8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
