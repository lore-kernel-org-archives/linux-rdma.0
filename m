From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] srp_daemon: fix CQ handling
Date: Tue, 12 Dec 2017 17:38:54 +0000
Message-ID: <1513100334.2999.21.camel@wdc.com>
References: <05bbb67fea5e3cae535c0d9d21866cf8ad76f74f.1513087686.git.NMoreyChaisemartin@suse.com>
         <19c1241b-6a22-f8c2-32a2-6233f62cc39c@suse.com>
         <1513098293.2999.15.camel@wdc.com>
         <e584830f-64a0-d5b6-c3b7-1cb6e0f4df90@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e584830f-64a0-d5b6-c3b7-1cb6e0f4df90-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Content-ID: <1344551B565144489842D56DE0CB9927-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "nmoreychaisemartin-IBi9RG/b67k@public.gmane.org" <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDE4OjI4ICswMTAwLCBOaWNvbGFzIE1vcmV5LUNoYWlzZW1h
cnRpbiB3cm90ZToNCj4gTGUgMTIvMTIvMjAxNyDDoCAxODowNCwgQmFydCBWYW4gQXNzY2hlIGEg
w6ljcml0IDoNCj4gPiBPbiBUdWUsIDIwMTctMTItMTIgYXQgMTU6MDggKzAxMDAsIE5pY29sYXMg
TW9yZXktQ2hhaXNlbWFydGluIHdyb3RlOg0KPiA+ID4gKwlpZiAocmV0IDwgMCkgew0KPiA+ID4g
KwkJcHJfZXJyKCJwb2xsIENRIGZhaWxlZFxuIik7DQo+ID4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+
ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCWlmIChyZXQgPiAwICYmIHdjLT5zdGF0dXMgIT0gSUJW
X1dDX1NVQ0NFU1MpIHsNCj4gPiA+ICsJCWlmICghc3RvcF90aHJlYWRzKHN5bmNfcmVzKSkNCj4g
PiA+ICsJCQlwcl9lcnIoImdvdCBiYWQgY29tcGxldGlvbiB3aXRoIHN0YXR1czogMHgleFxuIiwN
Cj4gPiA+ICsJCQkgICAgICAgd2MtPnN0YXR1cyk7DQo+ID4gPiArCQlyZXR1cm4gLXJldDsNCj4g
PiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gcmV0Ow0KPiA+ID4gK30NCj4gPiANCj4g
PiBUaGlzIGZ1bmN0aW9uIGNhbiByZXR1cm4gbmVnYXRpdmUgdmFsdWVzLCBwb3NpdGl2ZSB2YWx1
ZXMgb3IgemVyby4gUGxlYXNlDQo+ID4gbW9kaWZ5IGl0IHN1Y2ggdGhhdCBlaXRoZXIgMCBvciBh
IG5lZ2F0aXZlIFVuaXggZXJyb3IgY29kZSBpcyByZXR1cm5lZC4gVGhpcw0KPiA+IHdpbGwgbWFr
ZSBpdCBlYXNpZXIgdG8gcmVhZCB0aGlzIGZ1bmN0aW9uIGFuZCBhbHNvIHRoZSBjb2RlIHRoYXQg
Y2FsbHMgdGhpcw0KPiA+IGZ1bmN0aW9uLg0KPiANCj4gV2Ugc3RpbGwgbmVlZCB0byBkaWZmZXJl
bmNpYXRlIGJldHdlZW4gT0sgd2l0aCAwIGNvbXBsZXRpb25zIHBvbGxlZCwgYW5kIE9LIHdpdGgg
MSBjb21wbGV0aW9uLg0KPiBJIGRpZCBpdCB0aGlzIHdheSB0byBsaW1pdCB0aGUgc2lkZSBlZmZl
Y3Qgb2YgZmFjdG9yaW5nIHRoZSBjb2RlLg0KPiBXb3VsZCB5b3Ugd2FudCBwb2xsX2NxX29uY2Ug
dG8gcmV0dXJuIC1FQUdBSU4gIHdoZW4gbm8gY29tcGxldGlvbiB3YXMgZm91bmQ/DQoNCkhlbGxv
IE5pY29sYXMsDQoNCklmIHlvdSB0aGluayBhbm90aGVyIGFwcHJvYWNoIHdvdWxkIHdvcmsgYmV0
dGVyIGZvciB0aGUgcmV0dXJuIHZhbHVlcyB0aGFuDQp3aGF0IEkgcHJvcG9zZWQgaXQncyBmaW5l
IHRvIHVzZSB0aGF0IGFwcHJvYWNoLiBNeSBwcmltYXJ5IGNvbmNlcm4gaXMgdGhhdA0KdGhlIG1l
YW5pbmcgb2YgdGhlIHJldHVybiB2YWx1ZXMgZ2V0cyBkb2N1bWVudGVkIGFuZCBhbHNvIHRoYXQg
dGhlIG1lYW5pbmcNCm9mIHRoZSByZXR1cm4gdmFsdWVzIGlzIGNsZWFyIHdpdGhvdXQgaGF2aW5n
IHRvIHJlYWQgdGhlIGltcGxlbWVudGF0aW9uIG9mDQp0aGlzIGZ1bmN0aW9uLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
