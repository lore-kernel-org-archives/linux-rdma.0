From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 1/5] kobject: Export kobj_ns_grab_current() and
 kobj_ns_drop()
Date: Tue, 9 Jan 2018 18:47:29 +0000
Message-ID: <1515523648.2721.21.camel@wdc.com>
References: <20180108231436.19750-1-bart.vanassche@wdc.com>
         <20180108231436.19750-2-bart.vanassche@wdc.com>
         <1515520784.2721.11.camel@wdc.com> <20180109183047.GA3236@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109183047.GA3236-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <278B2727750CCD40A76EBC9B7D14974B-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTAxLTA5IGF0IDE5OjMwICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVHVlLCBKYW4gMDksIDIwMTggYXQgMDU6NTk6NDVQTSArMDAwMCwg
QmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IEknZCBsaWtlIHRvIHJlcG9zdCB0aGlzIHNlcmll
cyB0byBhZGRyZXNzIGEgYnVnIGluIHBhdGNoIDUvNSBvZiB0aGlzIHNlcmllcy4NCj4gPiBCdXQg
YmVmb3JlIEkgZG8gdGhhdCwgY2FuIHlvdSB0ZWxsIG1lIHdoZXRoZXIgSSBwZXJoYXBzIHNob3Vs
ZCB3aWRlbiB0aGUNCj4gPiBDYy1saXN0IGZvciBwYXRjaCAxLzUgb2YgdGhpcyBzZXJpZXM/DQo+
IA0KPiBJIGhhdmUgbm8gaWRlYSB3aHkgeW91IG5lZWQgdGhlc2UgZnVuY3Rpb25zLCBhcyBJIGRv
bid0IHNlZSBhbnkgb2YgdGhlc2UNCj4gb3RoZXIgcGF0Y2hlcy4gIFBsZWFzZSByZXNlbmQgdGhl
IHdob2xlIHNlcmllcyBwbGVhc2UuDQo+IA0KPiBJIHdpbGwgbm90ZSB0aGF0IG5vIGRyaXZlciBo
YWQgYmV0dGVyIGJlIG11Y2tpbmcgYXJvdW5kIHdpdGggYSAicmF3Ig0KPiBrb2JqZWN0LCBvciBJ
IGFtIGdvaW5nIHRvIGJlIHZlcnkgbWFkLi4uDQoNCkhlbGxvIEdyZWcsDQoNClRvIGFsbG93IHlv
dSB0byBoYXZlIGEgbG9vayBhdCB0aGUgY29kZSB0aGF0IGFkZHMgY2FsbHMgaW4gYSBtb2R1bGUg
dG8gdGhlDQpuYW1lc3BhY2UgZnVuY3Rpb25zIEkgaGFkIENjJ2VkIHlvdSBmb3IgdGhlIGVudGly
ZSBzZXJpZXMuIFBhdGNoIDUvNSBvZiB0aGlzDQpzZXJpZXMgYWRkcyBjYWxscyB0byB0aGUgbmFt
ZXNwYWNlIGZ1bmN0aW9ucyBleHBvcnRlZCB0aHJvdWdoIHRoaXMgcGF0Y2guDQpUaGF0IHBhdGNo
IGlzIGFsc28gYXZhaWxhYmxlIGhlcmU6DQpodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC1yZG1hL21zZzU5MTkwLmh0bWwuDQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
