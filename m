From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/6] RDMA/hfi1: Avoid redeclaration error
Date: Tue, 16 Aug 2016 17:15:39 +0000
Message-ID: <1471367729.2661.50.camel@intel.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
	 <1471355123-6227-4-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471355123-6227-4-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <1EEC89D8AFD1FA4EB38D032570FE4148-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE2LTA4LTE2IGF0IDE2OjQ1ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gDQo+IFBs
dWdnaW5nIEhGSTEgSU9DVEwgZGVmaW5lcyB3aWxsIGNhdXNlIHRvIHRoZSBmb2xsb3dpbmcNCj4g
YnVpbGQgZXJyb3IgZm9yIFFJQjoNCj4gwqAgQ0MgW01dIGRyaXZlcnMvaW5maW5pYmFuZC9ody9x
aWIvcWliX3N5c2ZzLm8NCj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVkZS91YXBpL3Jk
bWEvcmRtYV91c2VyX2lvY3RsLmg6Mzk6MCwNCj4gCQnCoGZyb20gaW5jbHVkZS91YXBpL3JkbWEv
aWJfdXNlcl9tYWQuaDozOCwNCj4gCQnCoGZyb20gaW5jbHVkZS9yZG1hL2liX21hZC5oOjQzLA0K
PiAJCcKgZnJvbSBpbmNsdWRlL3JkbWEvaWJfcG1hLmg6MzgsDQo+IAkJwqBmcm9tIGRyaXZlcnMv
aW5maW5pYmFuZC9ody9xaWIvcWliX21hZC5oOjM3LA0KPiAJCcKgZnJvbSBkcml2ZXJzL2luZmlu
aWJhbmQvaHcvcWliL3FpYl9pbml0LmM6NDk6DQo+IC4vaW5jbHVkZS91YXBpL3JkbWEvaGZpL2hm
aTFfdXNlci5oOjM3MDoyOiBlcnJvcjogcmVkZWNsYXJhdGlvbiBvZg0KPiBlbnVtZXJhdG9yIOKA
mHVyX3JjdmhkcnRhaWzigJkNCj4gwqAgdXJfcmN2aGRydGFpbCA9IDAsDQo+IE1vdmUgSEZJMSBz
dHJ1Y3R1cmVzIHRvIHNlcGFyYXRlIGZpbGUgdG8gYXZvaWQgdGhpcyBmYWlsdXJlLg0KDQpJIG5l
ZWQgdG8gbG9vayBhdCB0aGlzIHNvbWUgbW9yZS4gU28gZG9lcyB0aGlzIG1lYW4gdGhpcyBwYXRj
aCBzZXJpZXMNCmRvbid0IGJ1aWxkIGlmIHlvdSBqdXN0IHRha2UgdGhlIGZpcnN0IDI/IHFpYiBz
aG91bGQgbm90IG5lZWQgYW55dGhpbmcNCmZyb20gaGZpMV91c2VyLmggc28gaXQgc2hvdWxkIG5v
dCBiZSBpbmNsdWRpbmcgaXQuDQoNCi1EZW5ueQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
