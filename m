From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 20:11:53 +0000
Message-ID: <1486930299.2918.5.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <20170210235611.3243-9-bart.vanassche@sandisk.com>
         <20170212171928.GF14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170212171928.GF14015-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <1916B8E5E063564FBA5B62F2360C9E55-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gU3VuLCAyMDE3LTAyLTEyIGF0IDE5OjE5ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIEZyaSwgRmViIDEwLCAyMDE3IGF0IDAzOjU2OjExUE0gLTA4MDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiAtc3RhdGljIHZvaWQgc3JwX2Rlc3Ryb3lfcXAoc3RydWN0IGliX3Fw
ICpxcCkNCj4gPiArc3RhdGljIHZvaWQgc3JwX2Rlc3Ryb3lfcXAoc3RydWN0IHNycF9yZG1hX2No
ICpjaCwgc3RydWN0IGliX3FwICpxcCkNCj4gPiAgew0KPiA+IC0JaWJfZHJhaW5fcnEocXApOw0K
PiA+ICsJc3Bpbl9sb2NrX2lycSgmY2gtPmxvY2spOw0KPiA+ICsJaWJfcHJvY2Vzc19jcV9kaXJl
Y3QoY2gtPnNlbmRfY3EsIC0xKTsNCj4gDQo+IEkgc2VlIHRoYXQgeW91IGFyZSBhbHJlYWR5IHVz
aW5nICItMSIgaW4geW91ciBjb2RlLCBidXQgdGhlIGNvbW1lbnRzIGluIHRoZQ0KPiBpYl9wcm9j
ZXNzX2NxX2RpcmVjdCBzdGF0ZXMgdGhhdCBubyBuZXcgY29kZSBzaG91bGQgdXNlICItMSIuDQo+
IA0KPiAgNjEgICogTm90ZTogZm9yIGNvbXBhdGliaWxpdHkgcmVhc29ucyAtMSBjYW4gYmUgcGFz
c2VkIGluICVidWRnZXQgZm9yIHVubGltaXRlZA0KPiAgNjIgICogcG9sbGluZy4gIERvIG5vdCB1
c2UgdGhpcyBmZWF0dXJlIGluIG5ldyBjb2RlLCBpdCB3aWxsIGJlIHJlbW92ZWQgc29vbi4NCj4g
IDYzICAqLw0KPiAgNjQgaW50IGliX3Byb2Nlc3NfY3FfZGlyZWN0KHN0cnVjdCBpYl9jcSAqY3Es
IGludCBidWRnZXQpDQoNCkFsdGhvdWdoIGl0IGlzIHBvc3NpYmxlIHRvIGF2b2lkIHBhc3Npbmcg
LTEgYXMgJ2J1ZGdldCcgYnkgcGFzc2luZyBhIG51bWJlcg0KdGhhdCBpcyBhdCBsZWFzdCBhcyBs
YXJnZSBhcyB0aGUgbnVtYmVyIG9mIGV4cGVjdGVkIGNvbXBsZXRpb25zLCBpdCB3b3VsZA0KbWFr
ZSBpdCBoYXJkZXIgdG8gdmVyaWZ5IHRoZSBTUlAgaW5pdGlhdG9yIGRyaXZlci4gU28gSSBwcm9w
b3NlIHRvIG1vZGlmeQ0KdGhlIGNvbW1lbnQgYWJvdmUgaWJfcHJvY2Vzc19jcV9kaXJlY3QoKS4N
Cg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
