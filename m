From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 17 Aug 2016 13:45:21 +0000
Message-ID: <1471441516.19634.15.camel@intel.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
		 <1471355123-6227-7-git-send-email-leon@kernel.org>
		 <1471357887.2661.28.camel@intel.com> <20160816165041.GA5489@leon.nu>
		 <1471367364.2661.45.camel@intel.com> <20160817051952.GC5489@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160817051952.GC5489-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Content-ID: <142202CAB1014842B0D6D4EA68E089B9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE2LTA4LTE3IGF0IDA4OjE5ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQoNCg0KPiA+IEknbSBub3Qgb3Bwb3NlZCB0byB0cnlpbmcgdG8gdW5pZnkgdGhpbmdzLCBob3dl
dmVyIHRoaXMgc2VlbXMgdG8gYmUNCj4gPiBtb3JlIHRoYW4gcGxvcCBkb3duIHRoZSBoZmkxIHN0
dWZmIGZyb20gaGVyZSBhbmQgcHV0IGl0IG92ZXIgdGhlcmUuDQo+ID4gSXQNCj4gPiBpcyBjZXJ0
YWlubHkgbm90IHNpbXBsaWZ5aW5nIGFueXRoaW5nLg0KPiANCj4gSXQgaXMgImRhcmsgc2lkZSIg
b2YgVUFQSSAtIGluYWJpbGl0eSB0byBjaGFuZ2UgbGVnYWN5IGRlY2xhcmF0aW9ucy4NCj4gVGhp
cyBpcyB3aHkgSSBkaWRuJ3QgcmVtb3ZlIGFueXRoaW5nIGV4Y2VwdCBfTlVNKCkgbWFjcm8uDQo+
IA0KPiBUaGUgc2ltcGxpZmljYXRpb24gY29tZXMgZnJvbSBkZWZpbml0aW9uIG9mIG9uZSBwbGFj
ZSBmb3INCj4gZGVjbGFyYXRpb24gb2YgSU9DVExzIG51bWJlcnMgYW5kIGV4cG9ydGluZyBpdCB0
byB1c2Vycy4gSXQgZ2l2ZXMNCj4gdmlzaWJpbGl0eSBmb3IgdXNlciBzcGFjZSBhdXRob3JzIHRv
by4NCg0KSG93IG9mdGVuIGRvZXMgYSB1c2VyIG5lZWQgdGhlIElPQ1RMIG51bWJlcnMgZm9yIE1B
RCBhbmQgUFNNIGFuZA0Kd2hhdGV2ZXIgZWxzZSB3ZSBjb21lIHVwIHdpdGggYXQgdGhlIHNhbWUg
dGltZT8gV2h5IHdvdWxkIHRoZXkgY2FyZQ0KYWJvdXQgdGhlIG90aGVyIElPQ1RMIG51bWJlcnM/
wqANCg0KSSBkb24ndCByZWFsbHkgc2VlIGEgcHJvYmxlbSB3aXRoIGtlZXBpbmcgdGhlbSBzZXBh
cmF0ZSwgYnV0IEknbSBub3QNCnJlYWxseSBvcHBvc2VkIHRvIGNvbGxhcHNpbmcgaW50byBvbmUg
cGxhY2UgZWl0aGVyLg0KDQotRGVubnk=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
