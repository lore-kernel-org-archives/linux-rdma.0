From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Fri, 12 Jan 2018 06:32:47 +0000
Message-ID: <1515738766.10329.3.camel@wdc.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
         <1515620434.3403.169.camel@redhat.com>
         <1515621700.3403.174.camel@redhat.com>
         <20180111062252.GP7368@mtr-leonro.local> <1515686552.2752.2.camel@wdc.com>
         <20180111190045.GE15760@mtr-leonro.local>
         <1515697625.2752.46.camel@wdc.com>
         <20180112062359.GG15760@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112062359.GG15760-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <37501D70220DD7499824062E57AAE580-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTEyIGF0IDA4OjIzICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFRodSwgSmFuIDExLCAyMDE4IGF0IDA3OjA3OjA2UE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMTgtMDEtMTEgYXQgMjE6MDAgKzAyMDAsIExlb24g
Um9tYW5vdnNreSB3cm90ZToNCj4gPiA+IE9uIFRodSwgSmFuIDExLCAyMDE4IGF0IDA0OjAyOjMz
UE0gKzAwMDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiA+ID4gT24gVGh1LCAyMDE4LTAx
LTExIGF0IDA4OjIyICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+ID4gPiA+ID4gVGhl
IHByb3Bvc2VkIHBhdGNoIGRlZmluaXRlbHkgZGVjcmVhc2VzIHRoZSBjaGFuY2Ugb2YgcmFjZXMs
IGJ1dCBpdCBpcyBub3QgZml4aW5nIHRoZW0uDQo+ID4gPiA+ID4gVGhlcmUgaXMgYSBjaGFuY2Ug
dG8gaGF2ZSBjaGFuZ2UgaW4gcXAgc3RhdGUgaW1tZWRpYXRlbHkgYWZ0ZXIgeW91ciAiaWYgLi4u
IiBjaGVjay4NCj4gPiA+ID4gDQo+ID4gPiA+IEhlbGxvIExlb24sDQo+ID4gPiA+IA0KPiA+ID4g
PiBQbGVhc2UgaGF2ZSBhIGxvb2sgYXQgcnhlX3FwX2Vycm9yKCkgYW5kIHlvdSB3aWxsIHNlZSB0
aGF0IHRoZSBwYXRjaCBJIHBvc3RlZA0KPiA+ID4gPiBpcyBhIHByb3BlciBmaXguIEluIHRoZSBz
Y2VuYXJpbyB5b3UgZGVzY3JpYmVkIHJ4ZV9xcF9lcnJvcigpIHdpbGwgdHJpZ2dlciBhDQo+ID4g
PiA+IHJ1biBvZiByeGVfY29tcGxldGVyKCkuDQo+ID4gPiANCj4gPiA+IEJhcnQsDQo+ID4gPiAN
Cj4gPiA+IFdoYXQgYW0gSSBtaXNzaW5nPw0KPiA+ID4gDQo+ID4gPiBDUFUxCQkJCQkJCUNQVTIN
Cj4gPiA+IAkJCQkJCQlpZiAodW5saWtlbHkuLi4uDQo+ID4gPiAJCQkJCQk8LS0tDQo+ID4gPiAv
KiBtb3ZlIHRoZSBxcCB0byB0aGUgZXJyb3Igc3RhdGUgKi8NCj4gPiA+IHZvaWQgcnhlX3FwX2Vy
cm9yKHN0cnVjdCByeGVfcXAgKnFwKQ0KPiA+ID4gew0KPiA+ID4gICAgICAgICBxcC0+cmVxLnN0
YXRlID0gUVBfU1RBVEVfRVJST1I7DQo+ID4gPiAgICAgICAgIHFwLT5yZXNwLnN0YXRlID0gUVBf
U1RBVEVfRVJST1I7DQo+ID4gPiAgICAgICAgIHFwLT5hdHRyLnFwX3N0YXRlID0gSUJfUVBTX0VS
UjsNCj4gPiA+IAkJCQkJCS0tLT4NCj4gPiA+IAkJCQkJCQlyeGVfcnVuX3Rhc2soJnFwLT5yZXEu
dGFzaywgbXVzdF9zY2hlZCk7DQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBJdCBpcyBt
b3JlIG9yIGxlc3MgdGhlIHNhbWUgYXMgd2l0aG91dCAiaWYgKHVubGlrZWx5Li4uIg0KPiA+IA0K
PiA+IEhlbGxvIExlb24sDQo+ID4gDQo+ID4gSW4gdGhlIGFib3ZlIHRoZSBwYXJ0IG9mIHJ4ZV9x
cF9lcnJvcigpIHRoYXQgSSB3YXMgcmVmZXJyaW5nIHRvIGluIG15IGUtbWFpbA0KPiA+IGlzIG1p
c3Npbmc6DQo+ID4gDQo+ID4gCWlmIChxcF90eXBlKHFwKSA9PSBJQl9RUFRfUkMpDQo+ID4gCQly
eGVfcnVuX3Rhc2soJnFwLT5jb21wLnRhc2ssIDEpOw0KPiANCj4gDQo+IEJ1dCBpdCBpcyBleGFj
dGx5IHdoZXJlIHJhY2UgZXhpc3RzLCBhcyBsb25nIFFQIGlzbid0IHByb3RlY3RlZCwgaXQgY2Fu
DQo+IHN3aXRjaCBDUFVzIGFuZCBjcmVhdGUgcmFjZS4NCg0KSGVsbG8gTGVvbiwNCg0KQ2FuIHlv
dSBjbGFyaWZ5IHdoaWNoIHJhY2UgeW91IGFyZSByZWZlcnJpbmcgdG8/IHJ4ZV9ydW5fdGFzaygp
IHVzZXMgdGhlDQp0YXNrbGV0IG1lY2hhbmlzbSBhbmQgdGFza2xldHMgYXJlIGd1YXJhbnRlZWQg
dG8gcnVuIG9uIGF0IG1vc3Qgb25lIENQVSBhdCBhDQp0aW1lLiBTZWUgYWxzbyB0aGUgIlRvcCBh
bmQgQm90dG9tIEhhbHZlcyIgY2hhcHRlciBpbiBMaW51eCBEZXZpY2UgRHJpdmVycywNCjNyZCBl
ZGl0aW9uLiBTZWUgYWxzbyB0aGUgdGFza2xldF9zY2hlZHVsZSgpIGltcGxlbWVudGF0aW9uIGlu
DQo8bGludXgvaW50ZXJydXB0Lmg+IGFuZCBpbiBrZXJuZWwvc29mdGlycS5jLg0KDQpUaGFua3Ms
DQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
