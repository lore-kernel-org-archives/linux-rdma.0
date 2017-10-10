From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 13/47] RDMA/cxgb4: Declare a local variable 'static'
Date: Tue, 10 Oct 2017 16:16:54 +0000
Message-ID: <1507652210.2815.22.camel@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
         <20171006213333.6721-14-bart.vanassche@wdc.com>
         <01ba01d33eef$d3ed5a90$7bc80fb0$@opengridcomputing.com>
         <1507591219.2674.58.camel@wdc.com> <20171010035909.GI1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010035909.GI1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <1616314E8D2FBD4B9B23A2575065759E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTEwIGF0IDA2OjU5ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIE1vbiwgT2N0IDA5LCAyMDE3IGF0IDExOjIwOjIwUE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMTctMTAtMDYgYXQgMTc6MDkgLTA1MDAsIFN0ZXZl
IFdpc2Ugd3JvdGU6DQo+ID4gPiBDYW4gd2UganVzdCByZW1vdmUgdGhpcyBub3c/ICBJRSBoYXMg
aXQgYmVlbiAxIHJlbGVhc2Ugc2luY2UgaXQgd2FzIG9ic29sZXRlZD8NCj4gPiANCj4gPiBUaGF0
J3MgYSBnb29kIHF1ZXN0aW9uIGJ1dCBJJ20gbm90IHN1cmUgd2hhdCB3b3VsZCBiZSBhIGdvb2Qg
dGltZSB0byByZW1vdmUNCj4gPiB0aGlzLiBJIHRoaW5rIHRoZSBhbnN3ZXIgZGVwZW5kcyBvbiBo
b3cgbGlrZWx5IGl0IGlzIHRoYXQgcGVvcGxlIHVzZSB0aGlzDQo+ID4gdmFyaWFibGUgaW4gc2Ny
aXB0cyBvciAvZXRjL21vZHByb2JlLmQgY29uZmlndXJhdGlvbiBmaWxlcyBiZWNhdXNlIGluIHRo
YXQNCj4gPiBjYXNlIHJlbW92aW5nIHRoZSBtb2R1bGUgcGFyYW1ldGVyIHdvdWxkIGJyZWFrIHNl
dHVwcy4NCj4gDQo+IEl0IGlzIHVubGlrZWx5IHRvIGhhcHBlbiwgZm9yIG1hbnkgcmVhc29ucy4g
SXQgaXMgbWFya2VkIGFzIG9ic29sZXRlIGZvcg0KPiBhIGxvbmcgdGltZSwgdGhlIHByb3BlciBp
bmZyYXN0cnVjdHVyZSAoZHluYW1pYyBwcmludHMpIGFscmVhZHkgZm9yIGEgZGVjYWRlDQo+IHdp
dGggdXMgYW5kIG5vIGFkZXF1YXRlIHVzZXIgaXMgcnVubmluZyBkZWJ1ZyBzeXN0ZW0gaW4gcHJv
ZHVjdGlvbi4NCj4gDQo+IEFub3RoZXIgdGhpbmcgdGhhdCB3ZSBkbyByZW1vdmUgdmlzaWJsZSB0
byB1c2VyIGludGVyZmFjZXMgZnJvbSB0aW1lIHRvIHRpbWUNCj4gYW5kIHRoZSBydWxlIGlzICJ0
cnkgdG8gcmVtb3ZlIGl0IGFuZCBzZWUgaWYgc29tZW9uZSBzY3JlYW1zIGFib3V0IGl0Ii4NCj4g
DQo+IFRoZXJlIGFyZSBhIGxvdCBvZiBjb21taXRzIHdoaWNoIGRvIHN1Y2ggdGhpbmcgYW5kIGxh
dGVzdCBvbmUgaXMgMGQwYzcxYjMxNzIwDQo+ICgiYnRyZnM6IG9ic29sZXRlIGFuZCByZW1vdmUg
bW91bnQgb3B0aW9uIGFsbG9jX3N0YXJ0IikNCj4gDQo+IEl0IGlzIHNhZmUgdG8gcmVtb3ZlIGM0
aXdfZGVidWcgbW9kdWxlIHBhcmFtZXRlci4NCg0KT0ssIEkgd2lsbCByZW1vdmUgdGhhdCBtb2R1
bGUgcGFyYW1ldGVyLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
