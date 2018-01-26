From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH net-next 5/5] net/smc: return booleans instead of integers
Date: Fri, 26 Jan 2018 15:57:15 +0000
Message-ID: <1516982235.2651.3.camel@wdc.com>
References: <20180126082850.20655-1-ubraun@linux.vnet.ibm.com>
         <20180126082850.20655-6-ubraun@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126082850.20655-6-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Content-ID: <6BBAFADDF0416D47B6B10F9187A0461D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jwi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <jwi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDA5OjI4ICswMTAwLCBVcnN1bGEgQnJhdW4gd3JvdGU6DQo+
IEZyb206IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9AZW1iZWRkZWRvci5jb20+DQo+IA0K
PiBSZXR1cm4gc3RhdGVtZW50cyBpbiBmdW5jdGlvbnMgcmV0dXJuaW5nIGJvb2wgc2hvdWxkIHVz
ZQ0KPiB0cnVlL2ZhbHNlIGluc3RlYWQgb2YgMS8wLg0KPiANCj4gVGhpcyBpc3N1ZSB3YXMgZGV0
ZWN0ZWQgd2l0aCB0aGUgaGVscCBvZiBDb2NjaW5lbGxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
R3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b0BlbWJlZGRlZG9yLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogVXJzdWxhIEJyYXVuIDx1YnJhdW5AbGludXgudm5ldC5pYm0uY29tPg0KPiAtLS0NCj4g
IG5ldC9zbWMvc21jLmggfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3NtYy9zbWMuaCBiL25l
dC9zbWMvc21jLmgNCj4gaW5kZXggYmZiZTIwMjM0MTA1Li45NTE4OTg2Yzk3YjEgMTAwNjQ0DQo+
IC0tLSBhL25ldC9zbWMvc21jLmgNCj4gKysrIGIvbmV0L3NtYy9zbWMuaA0KPiBAQCAtMjUyLDEy
ICsyNTIsMTIgQEAgc3RhdGljIGlubGluZSBpbnQgc21jX3VuY29tcHJlc3NfYnVmc2l6ZSh1OCBj
b21wcmVzc2VkKQ0KPiAgc3RhdGljIGlubGluZSBib29sIHVzaW5nX2lwc2VjKHN0cnVjdCBzbWNf
c29jayAqc21jKQ0KPiAgew0KPiAgCXJldHVybiAoc21jLT5jbGNzb2NrLT5zay0+c2tfcG9saWN5
WzBdIHx8DQo+IC0JCXNtYy0+Y2xjc29jay0+c2stPnNrX3BvbGljeVsxXSkgPyAxIDogMDsNCj4g
KwkJc21jLT5jbGNzb2NrLT5zay0+c2tfcG9saWN5WzFdKSA/IHRydWUgOiBmYWxzZTsNCj4gIH0N
Cg0KSGVsbG8gVXJzdWxhLA0KDQpJZiB5b3UgZXZlciBoYXZlIHRvIHRvdWNoIHRoaXMgY29kZSBh
Z2FpbiwgcGxlYXNlIGZvbGxvdyB0aGUgc3R5bGUgb2Ygb3RoZXIga2VybmVsDQpjb2RlIGFuZCBs
ZWF2ZSBvdXQgdGhlICI/IHRydWUgOiBmYWxzZSIgcGFydCBhbmQgYWxzbyB0aGUgcGFyZW50aGVz
ZXMuIEJvdGggYXJlDQpzdXBlcmZsdW91cy4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
