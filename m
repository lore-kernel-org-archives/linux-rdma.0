From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ to
 using RC
Date: Thu, 2 Nov 2017 21:41:55 +0000
Message-ID: <1509658914.2484.21.camel@wdc.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
         <20171011172729.16984-5-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC6266931A@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC6266931A-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <10DB5CE5777A174A966E72404AD7B577-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTAyIGF0IDE4OjMwICswMDAwLCBNYXJjaW5pc3p5biwgTWlrZSB3cm90
ZToNCj4gPiBTdWJqZWN0OiBbUEFUQ0ggdjIgNC84XSBJQi9zcnB0OiBDaGFuZ2UgZGVmYXVsdCBi
ZWhhdmlvciBmcm9tIHVzaW5nIFNSUSB0bw0KPiA+IHVzaW5nIFJDDQo+IA0KPiBCYXJ0LCB0aGlz
IGxhc3Qgb2YgdGhlIDQgdGFyZ2V0IHBhdGNoZXMgY2F1c2VzIG91ciBpbnRlcm5hbCBTUlAgdGVz
dGluZyB0bw0KPiBmYWlsLg0KDQpTb3JyeSBmb3IgdGhpcy4gU2luY2UgSSBhc3N1bWUgdGhhdCB5
b3UgYXJlIHJlZmVycmluZyB0byB0ZXN0cyB3aXRoIHRoZSBxaWINCm9yIGhmaTEgZHJpdmVyIGFu
ZCBzaW5jZSBJIGRvIG5vdCBoYXZlIGFjY2VzcyB0byBhIHNldHVwIHdpdGggdGhhdCBoYXJkd2Fy
ZQ0KSSB3aWxsIGhhdmUgdG8gcmVseSBvbiB5b3UgZm9yIGZ1cnRoZXIgYW5hbHlzaXMuDQoNCj4g
SSdtIGxvb2tpbmcgYXQgd2h5IGJ1dC4uLg0KPiANCj4gPiBBZGQgbmV3IGNvbmZpZ2ZzIGF0dHJp
YnV0ZXMgdGhhdCBhbGxvdyB0byBjb25maWd1cmUgd2hpY2ggbW9kZSB0byB1c2UNCj4gPiAoL3N5
cy9rZXJuZWwvY29uZmlnL3RhcmdldC9zcnB0LyRHVUlELyRHVUlEL2F0dHJpYi91c2Vfc3JxKS4g
Tm90ZToNCj4gPiBvbmx5IHRoZSBhdHRyaWJ1dGUgZm9yIHBvcnQgMSBpcyByZWxldmFudCBvbiBt
dWx0aS1wb3J0IGFkYXB0ZXJzLg0KPiANCj4gSXQgbG9va3MgbGlrZSB0aGUgYWJvdmUgd29yayBh
cm91bmQgY2Fubm90IHdvcmsuDQo+IFRoZSB1c2Vfc3JxIGlzIHRlc3RlZCBhbmQgdGhlICBTUlEg
aXMgYWxsb2NhdGVkIHdoZW4gdGhlIGRldmljZSBpcyBhZGRlZC4NCj4gU2V0dGluZyBhIHRhcmdl
dCByZWxhdGl2ZSBhdHRyaWJ1dGUgaXMgdG9vIGxhdGUgaW4gdGhlIHNlcXVlbmNlIHRvIGVuYWJs
ZQ0KPiB0aGUgb2xkIFNSUSB1c2FnZS4NCg0KVGhhbmtzIGZvciB0aGUgcmVwb3J0LiBJIHdpbGwg
cG9zdCBhIHBhdGNoIHNlcmllcyB0byBhZGRyZXNzIHRoaXMuDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
