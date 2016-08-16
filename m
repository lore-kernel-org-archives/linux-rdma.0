From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/core: Unify style of IOCTL commands
Date: Tue, 16 Aug 2016 17:09:27 +0000
Message-ID: <1471367364.2661.45.camel@intel.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
	 <1471355123-6227-7-git-send-email-leon@kernel.org>
	 <1471357887.2661.28.camel@intel.com> <20160816165041.GA5489@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816165041.GA5489-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Content-ID: <C0D2FADD6926FE4CA8C793432A02BF7E-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE2LTA4LTE2IGF0IDE5OjUwICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgQXVnIDE2LCAyMDE2IGF0IDAyOjMxOjMyUE0gKzAwMDAsIERhbGVzc2FuZHJv
LCBEZW5uaXMgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE2LTA4LTE2IGF0IDE2OjQ1ICswMzAwLCBM
ZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+ID4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25y
b0BtZWxsYW5veC5jb20+DQo+ID4gPiANCj4gPiA+IE1BRCBhbmQgSEZJMSBoYXZlIGRpZmZlcmVu
dCBuYW1pbmcgY29udmVudGlvbiwgdGhpcyBwYXRjaA0KPiA+ID4gc2ltcGxpZmllcyBhbmQgdW5p
ZmllcyB0aGVpciBkZWZpbmVzIGFuZCBuYW1lcy4NCj4gPiANCj4gPiBJIGRvbid0IGtub3cgdGhh
dCBJIGFncmVlIHRoYXQgaXQgc2ltcGxpZmllcyB0aGluZ3MuIEl0IGNoYW5nZXMgYQ0KPiA+IGxv
dA0KPiA+IG9mIGNvZGUgZm9yIG5vdCBtdWNoIHJlYWwgdmFsdWUgaW4gbXkgb3Bpbmlvbi7CoA0K
PiA+IA0KPiA+IFdhcyB0aGlzIHNvbWV0aGluZyB0aGF0IHdhcyBkaXNjdXNzZWQgaW4gdGhlIHZl
cmJzIGNhbGw/IEkgaGF2ZSBub3QNCj4gPiBiZWVuIGFibGUgdG8gYXR0ZW5kIHRoYXQgdGhlIGxh
c3QgZmV3IHdlZWtzLg0KPiANCj4gSXQgd2FzIGRpc2N1c3NlZCBvdmVyIG1haWxzLCBmb3IgZXhh
bXBsZSBKYXNvbidzIG9waW5pb24gWzFdLA0KPiBDaHJpc3RvcGhlciBMYW1ldGVyJ3Mgb3Bpbmlv
biBbMl0sIENocmlzdG9waCBIZWxsd2lnJ3Mgb3BpbmlvbiBbM10uDQoNCkknbSBub3Qgb3Bwb3Nl
ZCB0byB0cnlpbmcgdG8gdW5pZnkgdGhpbmdzLCBob3dldmVyIHRoaXMgc2VlbXMgdG8gYmUNCm1v
cmUgdGhhbiBwbG9wIGRvd24gdGhlIGhmaTEgc3R1ZmYgZnJvbSBoZXJlIGFuZCBwdXQgaXQgb3Zl
ciB0aGVyZS4gSXQNCmlzIGNlcnRhaW5seSBub3Qgc2ltcGxpZnlpbmcgYW55dGhpbmcuDQoNCj4g
PiA+IEFzIHBhcnQgb2YgY2xlYW51cCwgdGhlIEhGSTEgX05VTSgpIG1hY3JvIHdhcyByZW1vdmVk
IGFuZCBNQUQNCj4gPiA+IGluZGV4ZXMgd2VyZSByZW5hbWVkLiBJdCBoYXMgYSBwb3RlbnRpYWwg
dG8gYnJlYWsgYXBwbGljYXRpb24NCj4gPiA+IHdoaWNoIHVzZSB0aGVzZSBkZWZpbmVzIGRpcmVj
dGx5Lg0KPiA+IA0KPiA+IFdoeSBkbyB5b3Ugd2FudCB0byByZW1vdmUgdGhlIF9OVU0oKSBtYWNy
byB0aGF0IERvdWcganVzdCBwdXQgaW4/DQo+IA0KPiBJdCBpcyBub3QgdXNlZCBhZnRlciByZWZh
Y3RvcmluZyBhbmQgSU1ITyB0aGlzIG1hY3JvIGRvZXNuJ3QNCj4gYmVsb25nIHRvIFVBUEksIHNp
bmNlIGl0IHdvdWxkbid0IGluIHVzZSBieSBhbnkgdXNlcnMsIGJ1dCBJJ2xsIGJlDQo+IGdsYWQg
dG8NCj4gZ2V0IGFuIGV4YW1wbGVzIG9mIGl0cyB1c2FnZSBpbiByZWFsIHVzZXIgc3BhY2UgYXBw
bGljYXRpb25zDQo+IChsaWJmYWJyaWM/Pz8pLCBpZiBhbnkuDQo+IA0KDQpUaGF0J3MgYSBmYWly
IHBvaW50LiBJIGNhbiBzZWUgZ2V0dGluZyByaWQgb2YgaXQgbm93Lg0KDQotRGVubnk=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
