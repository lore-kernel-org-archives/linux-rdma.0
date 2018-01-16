From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 2/7] RDMA/core: Add helper function to create
 named QPs
Date: Tue, 16 Jan 2018 21:35:42 +0000
Message-ID: <1516138540.2844.36.camel@wdc.com>
References: <20180115151255.30167-1-leon@kernel.org>
         <20180115151255.30167-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115151255.30167-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <239DD59A8E84E246BAB843FCBEA5178B-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE4LTAxLTE1IGF0IDE3OjEyICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IC0tLSBhL2luY2x1ZGUvcmRtYS9pYl92ZXJicy5oDQo+ICsrKyBiL2luY2x1ZGUvcmRtYS9p
Yl92ZXJicy5oDQo+IEBAIC0xMTQxLDYgKzExNDEsMTIgQEAgc3RydWN0IGliX3FwX2luaXRfYXR0
ciB7DQo+ICAJdTgJCQlwb3J0X251bTsNCj4gIAlzdHJ1Y3QgaWJfcndxX2luZF90YWJsZSAqcndx
X2luZF90Ymw7DQo+ICAJdTMyCQkJc291cmNlX3FwbjsNCj4gKw0KPiArCS8qDQo+ICsJICogTmFt
ZSBvZiBlbnRpdHkgd2hpY2ggY3JlYXRlZCB0aGlzIFFQLCBlbXB0eSBzdHJpbmcgbWVhbnMgdGhh
dA0KPiArCSAqIGl0IHdpbGwgYmUgdGFrZW4gYXV0b21hdGljYWxseSBmcm9tIHRhc2tfc3RydWN0
Lg0KPiArCSAqLw0KPiArCWNoYXIgY29tbVtUQVNLX0NPTU1fTEVOXTsNCj4gIH07DQoNCldoeSBp
cyBjb21tW10gYW4gYXJyYXk/IEZvciBxdWV1ZSBwYWlycyBjcmVhdGVkIGZyb20gdXNlciBzcGFj
ZSwgYXJlIHRoZXJlIGFueQ0KcXVldWUgcGFpcnMgdGhhdCBjYW4gbGl2ZSBsb25nZXIgdGhhbiB0
aGUgdGFzayB0aGF0IGNyZWF0ZWQgdGhlbT8gSWYgbm90LCBkb2VzDQp0aGF0IG1lYW4gdGhhdCBp
dCBpcyBzYWZlIHRvIGNoYW5nZSBjb21tIGludG8gYSBjb25zdCBjaGFyIHBvaW50ZXI/DQoNCkFk
ZGl0aW9uYWxseSwgcGxlYXNlIHVzZSB0aGUga2VybmVsLWRvYyBzeW50YXggdG8gZG9jdW1lbnQg
c3RydWN0dXJlIG1lbWJlcnMuDQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
