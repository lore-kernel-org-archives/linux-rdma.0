From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 11 Jan 2018 19:47:27 +0000
Message-ID: <1515700046.2752.52.camel@wdc.com>
References: <20180111153132.11143-1-leon@kernel.org>
         <20180111153132.11143-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111153132.11143-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <7E92F3C678E4034484C4211CC6AC1D8D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDE3OjMxICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+ICtzdHJ1Y3QgcmRtYV9yZXN0cmFja19lbnRyeSB7DQo+ICsgICAgICAgc3RydWN0IGxpc3Rf
aGVhZCAgICAgICAgbGlzdDsNCj4gKw0KPiArICAgICAgIC8qDQo+ICsgICAgICAgICogVGhlIGVu
dHJpZXMgYXJlIGZpbGxlZCBkdXJpbmcgcmRtYV9yZXN0cmFja19hZGQsDQo+ICsgICAgICAgICog
Y2FuIGJlIGF0dGVtcHRlZCB0byBiZSBmcmVlIGR1cmluZyByZG1hX3Jlc3RyYWNrX2RlbC4NCj4g
KyAgICAgICAgKg0KPiArICAgICAgICAqIEFzIGFuIGV4YW1wbGUgZm9yIHRoYXQsIHNlZSBtbHg1
IFFQcyB3aXRoIHR5cGUgTUxYNV9JQl9RUFRfSFdfR1NJDQo+ICsgICAgICAgICovDQo+ICsgICAg
ICAgYm9vbCAgICAgICAgICAgICAgICAgICAgdmFsaWQ7DQo+ICsNCj4gKyAgICAgICAvKg0KPiAr
ICAgICAgICAqIFNsZWVwYWJhbGUgUkNVIHRvIHByb3RlY3Qgb2JqZWN0IGRhdGEuDQo+ICsgICAg
ICAgICovDQo+ICsgICAgICAgc3RydWN0IHNyY3Vfc3RydWN0ICAgICAgc3JjdTsNCj4gKw0KPiAr
ICAgICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAgICAgICp0YXNrOw0KPiArICAgICAgIGNoYXIgICAg
ICAgICAgICAgICAgICAgICp0YXNrX2NvbW07DQo+ICt9Ow0KDQpQbGVhc2UgdXNlIHRoZSBrZXJu
ZWwtZG9jIHN5bnRheCB0byBkb2N1bWVudCB0aGUgbWVhbmluZyBvZiB0aGUgbmFtZXMgb2YgdGhl
DQpmaWVsZHMgaW4gdGhpcyBzdHJ1Y3R1cmUuIEl0IGlzIGUuZy4gbm9udHJpdmlhbCB0byBndWVz
cyB3aGF0ICJ0YXNrX2NvbW0iIHN0YW5kcw0KZm9yLiBUaGUgcHJlc2Vuc2Ugb2YgYSB0YXNrX3N0
cnVjdCBwb2ludGVyIGlzIGFsc28gbm9udHJpdmlhbC4NCg0KUFM6IEkgdGhpbmsgdGhlIHNwZWxs
aW5nIG9mICJTbGVlcGFiYWxlIiBzaG91bGQgYmUgZml4ZWQuDQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
