From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Mon, 5 Feb 2018 17:20:31 +0000
Message-ID: <1517851229.3764.15.camel@wdc.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
         <23dcfda7-eac1-ed13-b24e-3586c284ee55@grimberg.me>
         <1517849882.3764.13.camel@wdc.com>
         <CAJrWOzDwDAt-w08-zmhJHsgedTyGQ-Dp=vHTvmrdSz9st7npxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJrWOzDwDAt-w08-zmhJHsgedTyGQ-Dp=vHTvmrdSz9st7npxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <A9C3A2E6115D3740B79FE524EDE9DFD8-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE4LTAyLTA1IGF0IDE4OjE2ICswMTAwLCBSb21hbiBQZW55YWV2IHdyb3RlOg0K
PiBFdmVyeXRoaW5nIChmaW8gam9icywgc2V0dXAsIGV0YykgaXMgZ2l2ZW4gaW4gdGhlIHNhbWUg
bGluazoNCj4gDQo+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXJkbWEvbXNn
NDg3OTkuaHRtbA0KPiANCj4gYXQgdGhlIGJvdHRvbSB5b3Ugd2lsbCBmaW5kIGxpbmtzIG9uIGdv
b2dsZSBkb2NzIHdpdGggbWFueSBwYWdlcw0KPiBhbmQgYXJjaGl2ZWQgZmlvIGpvYnMgYW5kIHNj
cmlwdHMuIChJIGRvIG5vdCByZW1lbWJlciBleGFjdGx5LA0KPiBvbmUgeWVhciBwYXNzZWQsIGJ1
dCB0aGVyZSBzaG91bGQgYmUgZXZlcnl0aGluZykuDQo+IA0KPiBSZWdhcmRpbmcgc21hbGxlciBp
b2RlcHRoX2JhdGNoX3N1Ym1pdCAtIHRoYXQgZGVjcmVhc2VzIHBlcmZvcm1hbmNlLg0KPiBPbmNl
IEkgcGxheWVkIHdpdGggdGhhdCwgZXZlbiBpbnRyb2R1Y2VkIG5ldyBpb2RlcHRoX2JhdGNoX2Nv
bXBsZXRlX21heA0KPiBvcHRpb24gZm9yIGZpbywgYnV0IHRoZW4gSSBkZWNpZGVkIHRvIHN0b3Ag
YW5kIHNpbXBseSBjaG9zZSB0aGlzDQo+IGNvbmZpZ3VyYXRpb24sIHdoaWNoIHByb3ZpZGVzIG1l
IGZhc3Rlc3QgcmVzdWx0cy4NCg0KSGVsbG8gUm9tYW4sDQoNClRoYXQncyB3ZWlyZC4gRm9yIHdo
aWNoIHByb3RvY29scyBkaWQgcmVkdWNpbmcgaW9kZXB0aF9iYXRjaF9zdWJtaXQgbGVhZA0KdG8g
bG93ZXIgcGVyZm9ybWFuY2U6IGFsbCB0aGUgdGVzdGVkIHByb3RvY29scyBvciBvbmx5IHNvbWUg
b2YgdGhlbT8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
