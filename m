From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/hfi1: Disable by default
Date: Tue, 19 Jul 2016 17:32:01 +0000
Message-ID: <1468949518.8322.16.camel@intel.com>
References: <e6761c19-f301-ffc4-8283-ea958a387313@sandisk.com>
	 <11ad3ffc-f1e5-4c02-16bf-29216cb38d15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <11ad3ffc-f1e5-4c02-16bf-29216cb38d15-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <565874D2C9729448A5476751FFCF9D98-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE2LTA3LTE5IGF0IDEwOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZXJlIGlzIGEgc3RyaWN0IHBvbGljeSBpbiB0aGUgTGludXgga2VybmVsIHRoYXQgbmV3
IGRyaXZlcnMgbXVzdCBiZQ0KPiBkaXNhYmxlZCBieSBkZWZhdWx0LiBIZW5jZSBsZWF2ZSBvdXQg
dGhlICJkZWZhdWx0IG0iIGxpbmUgZnJvbQ0KPiBLY29uZmlnLg0KPiANCj4gRml4ZXM6IGY0OGFk
NjE0YzEwMCAoIklCL2hmaTE6IE1vdmUgZHJpdmVyIG91dCBvZiBzdGFnaW5nIikNCj4gU2lnbmVk
LW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCj4g
Q2M6IEp1YmluIEpvaG4gPGp1YmluLmpvaG5AaW50ZWwuY29tPg0KPiBDYzogRGVubmlzIERhbGVz
c2FuZHJvIDxkZW5uaXMuZGFsZXNzYW5kcm9AaW50ZWwuY29tPg0KPiBDYzogSXJhIFdlaW55IDxp
cmEud2VpbnlAaW50ZWwuY29tPg0KPiBDYzogTWlrZSBNYXJjaW5pc3p5biA8bWlrZS5tYXJjaW5p
c3p5bkBpbnRlbC5jb20+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC43Kw0K
PiAtLS0NCj4gwqBkcml2ZXJzL2luZmluaWJhbmQvaHcvaGZpMS9LY29uZmlnIHwgMSAtDQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2luZmluaWJhbmQvaHcvaGZpMS9LY29uZmlnDQo+IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2hm
aTEvS2NvbmZpZw0KPiBpbmRleCBhOTI1ZmIwLi5mODQ2ZmQ1IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL2luZmluaWJhbmQvaHcvaGZpMS9LY29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9oZmkxL0tjb25maWcNCj4gQEAgLTMsNyArMyw2IEBAIGNvbmZpZyBJTkZJTklCQU5EX0hG
STENCj4gwqAJZGVwZW5kcyBvbiBYODZfNjQgJiYgSU5GSU5JQkFORF9SRE1BVlQNCj4gwqAJc2Vs
ZWN0IE1NVV9OT1RJRklFUg0KPiDCoAlzZWxlY3QgQ1JDMzINCj4gLQlkZWZhdWx0IG0NCj4gwqAJ
LS0taGVscC0tLQ0KPiDCoAlUaGlzIGlzIGEgbG93LWxldmVsIGRyaXZlciBmb3IgSW50ZWwgT1BB
IEdlbjEgYWRhcHRlci4NCj4gwqBjb25maWcgSEZJMV9ERUJVR19TRE1BX09SREVSDQoNClRoYW5r
cy4NCg0KQWNrZWQtYnk6IERlbm5pcyBEYWxlc3NhbmRybyA8ZGVubmlzLmRhbGVzc2FuZHJvQGlu
dGVsLmNvbT4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
