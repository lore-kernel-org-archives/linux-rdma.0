From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Fri, 2 Feb 2018 17:05:07 +0000
Message-ID: <1517591106.2675.28.camel@sandisk.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Content-ID: <CBAACF90A619034891C8DA0601EB1CDC-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE4LTAyLTAyIGF0IDE1OjA4ICswMTAwLCBSb21hbiBQZW4gd3JvdGU6DQo+IG8g
U2ltcGxlIGNvbmZpZ3VyYXRpb24gb2YgSUJOQkQ6DQo+ICAgIC0gU2VydmVyIHNpZGUgaXMgY29t
cGxldGVseSBwYXNzaXZlOiB2b2x1bWVzIGRvIG5vdCBuZWVkIHRvIGJlDQo+ICAgICAgZXhwbGlj
aXRseSBleHBvcnRlZC4NCg0KVGhhdCBzb3VuZHMgbGlrZSBhIHNlY3VyaXR5IGhvbGU/IEkgdGhp
bmsgdGhlIGFiaWxpdHkgdG8gY29uZmlndXJlIHdoZXRoZXIgb3INCm5vdCBhbiBpbml0aWF0b3Ig
aXMgYWxsb3dlZCB0byBsb2cgaW4gaXMgZXNzZW50aWFsIGFuZCBhbHNvIHdoaWNoIHZvbHVtZXMg
YW4NCmluaXRpYXRvciBoYXMgYWNjZXNzIHRvLg0KDQo+ICAgIC0gT25seSBJQiBwb3J0IEdJRCBh
bmQgZGV2aWNlIHBhdGggbmVlZGVkIG9uIGNsaWVudCBzaWRlIHRvIG1hcA0KPiAgICAgIGEgYmxv
Y2sgZGV2aWNlLg0KDQpJIHRoaW5rIElQIGFkZHJlc3NpbmcgaXMgcHJlZmVycmVkIG92ZXIgR0lE
IGFkZHJlc3NpbmcgaW4gUm9DRSBuZXR3b3Jrcy4NCkFkZGl0aW9uYWxseSwgaGF2ZSB5b3Ugbm90
aWNlZCB0aGF0IEdVSUQgY29uZmlndXJhdGlvbiBzdXBwb3J0IGhhcyBiZWVuIGFkZGVkDQp0byB0
aGUgdXBzdHJlYW0gaWJfc3JwdCBkcml2ZXI/IFVzaW5nIEdJRHMgaGFzIGEgdmVyeSBpbXBvcnRh
bnQgZGlzYWR2YW50YWdlLA0KbmFtZWx5IHRoYXQgYXQgbGVhc3QgaW4gSUIgbmV0d29ya3MgdGhl
IHByZWZpeCB3aWxsIGNoYW5nZSBpZiB0aGUgc3VibmV0DQptYW5hZ2VyIGlzIHJlY29uZmlndXJl
ZC4gQWRkaXRpb25hbGx5LCBpbiBJQiBuZXR3b3JrcyBpdCBtYXkgaGFwcGVuIHRoYXQgdGhlDQp0
YXJnZXQgZHJpdmVyIGlzIGxvYWRlZCBhbmQgY29uZmlndXJlZCBiZWZvcmUgdGhlIEdJRCBoYXMg
YmVlbiBhc3NpZ25lZCB0bw0KYWxsIFJETUEgcG9ydHMuDQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
