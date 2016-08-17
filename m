From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/core: Move HFI1 IOCTL declarations
 to common file
Date: Wed, 17 Aug 2016 13:35:53 +0000
Message-ID: <1471440949.19634.7.camel@intel.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
	 <1471355123-6227-5-git-send-email-leon@kernel.org>
	 <20160817061630.GB27477@phlsvsds.ph.intel.com>
	 <20160817065529.GG5489@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160817065529.GG5489-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Content-ID: <A22809A3704D3C42BD5679A9EB690145-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE2LTA4LTE3IGF0IDA5OjU1ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFdlZCwgQXVnIDE3LCAyMDE2IGF0IDAyOjE2OjMxQU0gLTA0MDAsIGlyYS53ZWlueSB3
cm90ZToNCj4gPiBPbiBUdWUsIEF1ZyAxNiwgMjAxNiBhdCAwNDo0NToyMVBNICswMzAwLCBMZW9u
IFJvbWFub3Zza3kgd3JvdGU6DQo+ID4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0Bt
ZWxsYW5veC5jb20+DQo+ID4gPiANCj4gPiA+IE1vdmUgSEZJMSBJT0NUTCBkZWNsYXJhdGlvbnMg
dG8gcmRtYV91c2VyX2lvY3RsLmggZmlsZS4NCj4gPiANCj4gPiBJIGhhdmUgbm90IHRyaWVkIHdp
dGggdGhlIHBhdGNoIGJ1dCBJJ20gOTklIHN1cmUgdGhpcyB3aWxsIGJyZWFrDQo+ID4gdGhlIFBT
TTINCj4gPiBsaWJyYXJ5IGJ1aWxkIHdoaWNoIGluY2x1ZGVzIGhmaTFfdXNlci5oLg0KPiA+IA0K
PiA+IFRoaXMgaXMgb25lIG9mIHRob3NlIHRoaW5ncyBJIGhhdmUgcG9uZGVyZWQgaW4gdGhlIHBh
c3QuwqDCoE1vc3Qgb2YNCj4gPiB0aGUgcmRtYQ0KPiA+IGxpYnJhcmllcyBkb24ndCBhY3R1YWxs
eSB1c2UgdGhlc2UgZGVmaW5pdGlvbnMgZGlyZWN0bHkuwqDCoFBTTTINCj4gPiBkb2VzLg0KPiAN
Cj4gSSdtIG5vdCBzbyBjb252aW5jZWQgYWJvdXQgaXQuDQo+ICIjaW5jbHVkZSA8cmRtYS9yZG1h
X3VzZXJfaW9jdGwuaD4iIHdhcyBhZGRlZCB0byBoZmkxX3VzZXIuaCB0byBzaGFyZQ0KPiBhbGwg
ZGVmaW5pdGlvbnMuIFBTTTIgbGlicmFyeSB3aWxsIHNlZSBpdC4NCg0KT24gZmFjZSB2YWx1ZSB0
aGF0IHNob3VsZCBiZSB0cnVlLiBJIHdvdWxkIHdhbnQgdG8gcnVuIGl0IGJ5IHRoZSBQU00NCmZv
bGtzIGFuZCB0ZXN0IGl0IG91dCB0aG91Z2ggdG8gYmUgc3VyZS4NCg0KDQoNCj4gPiBJJ20gbm90
IHN1cmUgd2hhdCBvdGhlciBsaWJyYXJpZXMgZG8uDQo+ID4gDQo+ID4gSW4gdGhlIGZpbmFsIHBh
dGNoIG9mIHRoaXMgc2VyaWVzIHlvdSBhZG1pdCB0aGF0IHRoZSBuYW1lIGNoYW5nZXMNCj4gPiBp
biB0aGF0IHBhdGNoDQo+ID4gd2lsbCBicmVhayB1c2Vyc3BhY2Ugd2hpY2ggdXNlcyB0aGUgZGVm
aW5lcyBkaXJlY3RseS7CoMKgQ2FuIHdlLA0KPiA+IHNob3VsZCB3ZSwgZG8NCj4gPiB0aGF0Pw0K
PiANCj4gSSdtIHRhbGtpbmcgYWJvdXQgX19OVU0oKSBtYWNyb3MuDQo+IA0KPiBEbyB5b3UgcmVh
bGx5IHVzZSBfX05VTShBU1NJR05fQ1RYVCkgaW4gdXNlciBhcHBsaWNhdGlvbj8gV2h5IGRpZCB5
b3UNCj4gZG8NCj4gaXQ/IFlvdSBzdXBwb3NlZCB0byB1c2UgSEZJMV9JT0NUTF9BU1NJR05fQ1RY
VCBpbnN0ZWFkLg0KDQpZZWFoIEkgdGhpbmsgd2UgY2FuIGdldCByaWQgb2YgdGhlIF9fTlVNKCkg
bWFjcm8uIEl0IHNob3VsZCBub3QNCnN0cmljdGx5IGJlIG5lZWRlZCBieSB1c2VyIHNwYWNlLiBV
c2VyIHNob3VsZCBiZSB1c2luZyB0aGUgdGhpbmcgdGhhdA0KX19OVU0oKSB3YXMgdXNlZCBpbiwg
dGhlIElPQ1RMIG51bWJlci4NCg0KLURlbm55
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
