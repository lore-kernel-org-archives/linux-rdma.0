From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 16:01:51 +0000
Message-ID: <1518192109.2871.5.camel@wdc.com>
References: <20180208233829.GA16128@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180208233829.GA16128-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Content-ID: <98A4DE662B41B4488D4CCF8659BA2CA9-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAyLTA4IGF0IDE2OjM4IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+ICBlbnVtIHsNCj4gLQlNTFg0X1dRRV9CSU5EX1RZUEVfMgkJPSAoMTw8MzEpLA0KPiArCU1M
WDRfV1FFX0JJTkRfVFlQRV8yCQk9ICgxVUw8PDMxKSwNCj4gIAlNTFg0X1dRRV9CSU5EX1pFUk9f
QkFTRUQJPSAoMTw8MzApLA0KPiAgfTsNCg0KSGVsbG8gSmFzb24sDQoNCkEgcXVvdGUgZnJvbSB0
aGUgQzExIHN0YW5kYXJkOg0KDQoiVGhlIGV4cHJlc3Npb24gdGhhdCBkZWZpbmVzIHRoZSB2YWx1
ZSBvZiBhbiBlbnVtZXJhdGlvbiBjb25zdGFudCBzaGFsbCBiZSBhbg0KaW50ZWdlciBjb25zdGFu
dCBleHByZXNzaW9uIHRoYXQgaGFzIGEgdmFsdWUgcmVwcmVzZW50YWJsZSBhcyBhbiBpbnQuIFsg
Li4uIF0NCkVhY2ggZW51bWVyYXRlZCB0eXBlIHNoYWxsIGJlIGNvbXBhdGlibGUgd2l0aCBjaGFy
LCBhIHNpZ25lZCBpbnRlZ2VyIHR5cGUsIG9yDQphbiB1bnNpZ25lZCBpbnRlZ2VyIHR5cGUuIFRo
ZSBjaG9pY2Ugb2YgdHlwZSBpcyBpbXBsZW1lbnRhdGlvbi1kZWZpbmVkIGJ1dA0Kc2hhbGwgYmUg
Y2FwYWJsZSBvZiByZXByZXNlbnRpbmcgdGhlIHZhbHVlcyBvZiBhbGwgdGhlIG1lbWJlcnMgb2Yg
dGhlDQplbnVtZXJhdGlvbi4iDQoNCkRvZXMgdGhhdCBtZWFuIHRoYXQgdGhpcyBjaGFuZ2UgcmVs
aWVzIG9uIGV4dGVuc2lvbnMgdG8gdGhlIEMgc3RhbmRhcmQ/DQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
