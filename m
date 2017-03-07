From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/2] device: Stop requiring that struct device is embedded
 in struct pci_dev
Date: Tue, 7 Mar 2017 05:20:54 +0000
Message-ID: <VI1PR0502MB300892FC23D3BC824F8418F1D12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
         <20170307003549.3872-2-bart.vanassche@sandisk.com>
         <20170307045236.GC3913@kroah.com>
         <VI1PR0502MB3008BEC2FB8747DDA40A10FCD12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1488863593.2997.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488863593.2997.3.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgQmFydCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1y
ZG1hLW93bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXJkbWEtDQo+IG93bmVyQHZn
ZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIEJhcnQgVmFuIEFzc2NoZQ0KPiBTZW50OiBNb25k
YXksIE1hcmNoIDYsIDIwMTcgMTE6MTMgUE0NCj4gVG86IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVs
bGFub3guY29tPjsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0KPiBzZWJvdHRA
bGludXgudm5ldC5pYm0uY29tOyBsaW51eEBhcm1saW51eC5vcmcudWs7IGhwYUB6eXRvci5jb207
DQo+IG1pbmdvQHJlZGhhdC5jb207IGR3bXcyQGluZnJhZGVhZC5vcmc7IGJoZWxnYWFzQGdvb2ds
ZS5jb207DQo+IGRsZWRmb3JkQHJlZGhhdC5jb207IGJlbmhAa2VybmVsLmNyYXNoaW5nLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIDEvMl0gZGV2aWNlOiBTdG9wIHJlcXVpcmluZyB0aGF0IHN0
cnVjdCBkZXZpY2UgaXMNCj4gZW1iZWRkZWQgaW4gc3RydWN0IHBjaV9kZXYNCj4gDQo+IE9uIFR1
ZSwgMjAxNy0wMy0wNyBhdCAwNTowOCArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEkg
cmVwbGllZCB3aXRoIHBzZXVkbyBjb2RlIGluIHByZXZpb3VzIHJlcGx5IHRvIEJhcnQgdG8gYnJp
bmcgYmFjaw0KPiBkbWFfZGV2aWNlIG1lbWJlciBpbiB0aGUgaWJfZGV2aWNlLg0KPiA+IGRtYV9k
ZXZpY2UgbWVtYmVyIHdhcyBhbHJlYWR5IHByZXNlbnQgaW4gbmVhciBwYXN0IG9mIGZldyB3ZWVr
cy4NCj4gPiBJdCBzaG91bGQgYmUgYWJsZSB0byB3b3JrIHVzaW5nIGl0IHdpdGhvdXQgcGVyZm9y
bWFuY2UgaW1wYWN0IGFuZCB3aXRob3V0DQo+IHRvdWNoaW5nIGRyaXZlciBjb3JlIGxheWVyIGxp
a2UgaW4gdGhpcyBwYXRjaC4NCj4gDQo+IFRoYXQncyBjb25mdXNpbmcgYW5kIHdhcyBhIHNvdXJj
ZSBvZiBidWdzIGFuZCBpbmNvbnNpc3RlbmNpZXMuIFdlIGRvIG5vdA0KPiB3YW50IHR3byBkZXZp
Y2Ugc3RydWN0dXJlcyBpbiBzdHJ1Y3QgaWJfZGV2aWNlIChzdHJ1Y3QgZGV2aWNlIGRldiBhbmQg
c3RydWN0DQo+IGRldmljZSAqZG1hX2RldmljZSkuDQoNCmRldmljZSBkZXYgcmVwcmVzZW50cywg
ZGV2IHN0cnVjdHVyZSBvZiB0aGUgaWJfZGV2aWNlLg0KV2hpbGUgZG1hX2RldmljZSBpcyBmb3Ig
dGhlIGFjdHVhbCBkZXZpY2UgYXMgeW91IGtub3cuDQoNCklmIHlvdSBsb29rIGF0IG5ldF9kZXZp
Y2UsIA0KSXQgaGFzIGRldmljZSBkZXYuDQp2ZW5kb3IgZHJpdmVycyBzdG9yZSBwY2lfZGV2IHBv
aW50ZXIgYW5kIGFjY2VzcyBkZXZpY2Ugb2YgcGNpX2RldiBldGMuDQpFdmVyeSBuZXRfZGV2aWNl
IGRyaXZlciBoYXMgdG8gZG8gdGhhdC4NCg0KSWJfZGV2aWNlIHNpbXBsaWZpZXMgdGhhdCB3b3Jr
IGZvciBpYiBzdGFjayBieSBzdG9yaW5nIGRtYV9kZXZpY2UuDQpJIHRoaW5rIHRoaXMgaXMgbGVz
cyBjb25mdXNpbmcuDQoNCj4gDQo+IEJhcnQuTiAgICAgciAgeSAgIGIgWCAgx6d2IF4gKd66ey5u
ICsgICAgeyAg2Zoge2F5IB3Kh9qZICxqICAgZiAgIGggICB6IB4gdyAgICAgICBqOit2ICAgdyBq
IG0gICAgICAgICB6WisNCj4g3aJqIiAgISBpDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
