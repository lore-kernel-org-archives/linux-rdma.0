From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Thu, 11 Jan 2018 19:07:06 +0000
Message-ID: <1515697625.2752.46.camel@wdc.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
         <1515620434.3403.169.camel@redhat.com>
         <1515621700.3403.174.camel@redhat.com>
         <20180111062252.GP7368@mtr-leonro.local> <1515686552.2752.2.camel@wdc.com>
         <20180111190045.GE15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180111190045.GE15760@mtr-leonro.local>
Content-Language: en-US
Content-ID: <21027316AF6ED747B15F899D64765227@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "leon@kernel.org" <leon@kernel.org>
Cc: "jgg@mellanox.com" <jgg@mellanox.com>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDIxOjAwICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFRodSwgSmFuIDExLCAyMDE4IGF0IDA0OjAyOjMzUE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMTgtMDEtMTEgYXQgMDg6MjIgKzAyMDAsIExlb24g
Um9tYW5vdnNreSB3cm90ZToNCj4gPiA+IFRoZSBwcm9wb3NlZCBwYXRjaCBkZWZpbml0ZWx5IGRl
Y3JlYXNlcyB0aGUgY2hhbmNlIG9mIHJhY2VzLCBidXQgaXQgaXMgbm90IGZpeGluZyB0aGVtLg0K
PiA+ID4gVGhlcmUgaXMgYSBjaGFuY2UgdG8gaGF2ZSBjaGFuZ2UgaW4gcXAgc3RhdGUgaW1tZWRp
YXRlbHkgYWZ0ZXIgeW91ciAiaWYgLi4uIiBjaGVjay4NCj4gPiANCj4gPiBIZWxsbyBMZW9uLA0K
PiA+IA0KPiA+IFBsZWFzZSBoYXZlIGEgbG9vayBhdCByeGVfcXBfZXJyb3IoKSBhbmQgeW91IHdp
bGwgc2VlIHRoYXQgdGhlIHBhdGNoIEkgcG9zdGVkDQo+ID4gaXMgYSBwcm9wZXIgZml4LiBJbiB0
aGUgc2NlbmFyaW8geW91IGRlc2NyaWJlZCByeGVfcXBfZXJyb3IoKSB3aWxsIHRyaWdnZXIgYQ0K
PiA+IHJ1biBvZiByeGVfY29tcGxldGVyKCkuDQo+IA0KPiBCYXJ0LA0KPiANCj4gV2hhdCBhbSBJ
IG1pc3Npbmc/DQo+IA0KPiBDUFUxCQkJCQkJCUNQVTINCj4gCQkJCQkJCWlmICh1bmxpa2VseS4u
Li4NCj4gCQkJCQkJPC0tLQ0KPiAvKiBtb3ZlIHRoZSBxcCB0byB0aGUgZXJyb3Igc3RhdGUgKi8N
Cj4gdm9pZCByeGVfcXBfZXJyb3Ioc3RydWN0IHJ4ZV9xcCAqcXApDQo+IHsNCj4gICAgICAgICBx
cC0+cmVxLnN0YXRlID0gUVBfU1RBVEVfRVJST1I7DQo+ICAgICAgICAgcXAtPnJlc3Auc3RhdGUg
PSBRUF9TVEFURV9FUlJPUjsNCj4gICAgICAgICBxcC0+YXR0ci5xcF9zdGF0ZSA9IElCX1FQU19F
UlI7DQo+IAkJCQkJCS0tLT4NCj4gCQkJCQkJCXJ4ZV9ydW5fdGFzaygmcXAtPnJlcS50YXNrLCBt
dXN0X3NjaGVkKTsNCj4gDQo+IA0KPiANCj4gSXQgaXMgbW9yZSBvciBsZXNzIHRoZSBzYW1lIGFz
IHdpdGhvdXQgImlmICh1bmxpa2VseS4uLiINCg0KSGVsbG8gTGVvbiwNCg0KSW4gdGhlIGFib3Zl
IHRoZSBwYXJ0IG9mIHJ4ZV9xcF9lcnJvcigpIHRoYXQgSSB3YXMgcmVmZXJyaW5nIHRvIGluIG15
IGUtbWFpbA0KaXMgbWlzc2luZzoNCg0KCWlmIChxcF90eXBlKHFwKSA9PSBJQl9RUFRfUkMpDQoJ
CXJ4ZV9ydW5fdGFzaygmcXAtPmNvbXAudGFzaywgMSk7DQoNCkJhcnQu
