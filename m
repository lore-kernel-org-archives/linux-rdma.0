From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/rdmavt: Disable by default
Date: Tue, 19 Jul 2016 17:31:41 +0000
Message-ID: <1468949498.8322.15.camel@intel.com>
References: <e6761c19-f301-ffc4-8283-ea958a387313@sandisk.com>
	 <8cbeb5a3-5d16-5de2-8251-4e9d5b9688ac@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8cbeb5a3-5d16-5de2-8251-4e9d5b9688ac-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <D73F6F9240BFD14C8F74021D786AA247-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE2LTA3LTE5IGF0IDEwOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZXJlIGlzIGEgc3RyaWN0IHBvbGljeSBpbiB0aGUgTGludXgga2VybmVsIHRoYXQgbmV3
IGRyaXZlcnMgbXVzdCBiZQ0KPiBkaXNhYmxlZCBieSBkZWZhdWx0LiBIZW5jZSBsZWF2ZSBvdXQg
dGhlICJkZWZhdWx0IG0iIGxpbmUgZnJvbQ0KPiBLY29uZmlnLg0KPiANCj4gRml4ZXM6IDAxOTQ2
MjFiMjI1MyAoIklCL3JkbWF2dDogQ3JlYXRlIG1vZHVsZSBmcmFtZXdvcmsgYW5kIGhhbmRsZQ0K
PiBkcml2ZXIgcmVnaXN0cmF0aW9uIikNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hl
IDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCj4gQ2M6IEp1YmluIEpvaG4gPGp1YmluLmpv
aG5AaW50ZWwuY29tPg0KPiBDYzogRGVubmlzIERhbGVzc2FuZHJvIDxkZW5uaXMuZGFsZXNzYW5k
cm9AaW50ZWwuY29tPg0KPiBDYzogSXJhIFdlaW55IDxpcmEud2VpbnlAaW50ZWwuY29tPg0KPiBD
YzogTWlrZSBNYXJjaW5pc3p5biA8bWlrZS5tYXJjaW5pc3p5bkBpbnRlbC5jb20+DQo+IENjOiA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC42Kw0KPiAtLS0NCj4gwqBkcml2ZXJzL2luZmlu
aWJhbmQvc3cvcmRtYXZ0L0tjb25maWcgfCAxIC0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQv
S2NvbmZpZw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yZG1hdnQvS2NvbmZpZw0KPiBpbmRl
eCAxMWFhNmEzLi4xZGE4ZDAxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvc3cv
cmRtYXZ0L0tjb25maWcNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL3N3L3JkbWF2dC9LY29u
ZmlnDQo+IEBAIC0xLDYgKzEsNSBAQA0KPiDCoGNvbmZpZyBJTkZJTklCQU5EX1JETUFWVA0KPiDC
oAl0cmlzdGF0ZSAiUkRNQSB2ZXJicyB0cmFuc3BvcnQgbGlicmFyeSINCj4gwqAJZGVwZW5kcyBv
biA2NEJJVA0KPiAtCWRlZmF1bHQgbQ0KPiDCoAktLS1oZWxwLS0tDQo+IMKgCVRoaXMgaXMgYSBj
b21tb24gc29mdHdhcmUgdmVyYnMgcHJvdmlkZXIgZm9yIFJETUEgbmV0d29ya3MuDQoNClRoYW5r
cy4NCg0KQWNrZWQtYnk6IERlbm5pcyBEYWxlc3NhbmRybyA8ZGVubmlzLmRhbGVzc2FuZHJvQGlu
dGVsLmNvbT4NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
