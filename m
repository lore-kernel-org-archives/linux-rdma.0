From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 05/24] ibtrs: client: main functionality
Date: Mon, 5 Feb 2018 16:24:12 +0000
Message-ID: <1517847851.3764.8.camel@wdc.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
         <20180202140904.2017-6-roman.penyaev@profitbricks.com>
         <c593c579-c5b9-8a3e-10dd-c7731b91b55a@grimberg.me>
         <CAJrWOzBRar_YjYJMYcmk7tr7o+L7TdrXLv78dL84zV2zvTDJGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJrWOzBRar_YjYJMYcmk7tr7o+L7TdrXLv78dL84zV2zvTDJGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <8BF381F58AA99944A639F0792CA901CA-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE4LTAyLTA1IGF0IDE1OjE5ICswMTAwLCBSb21hbiBQZW55YWV2IHdyb3RlOg0K
PiBPbiBNb24sIEZlYiA1LCAyMDE4IGF0IDEyOjE5IFBNLCBTYWdpIEdyaW1iZXJnIDxzYWdpQGdy
aW1iZXJnLm1lPiB3cm90ZToNCj4gPiBEbyB5b3UgYWN0dWFsbHkgZXZlciBoYXZlIHJlbW90ZSB3
cml0ZSBhY2Nlc3MgaW4geW91ciBwcm90b2NvbD8NCj4gDQo+IFdlIGRvIG5vdCBoYXZlIHJlYWRz
LCBpbnN0ZWFkIGNsaWVudCB3cml0ZXMgb24gd3JpdGUgYW5kIHNlcnZlciB3cml0ZXMNCj4gb24g
cmVhZC4gKHdyaXRlIG9ubHkgc3RvcmFnZSBzb2x1dGlvbiA6KQ0KDQpTbyB0aGVyZSBhcmUgbm8g
cmVzdHJpY3Rpb25zIG9uIHdoaWNoIGNsaWVudHMgY2FuIGxvZyBpbiBhbmQgYW55IGNsaWVudCBj
YW4NCnNlbmQgUkRNQSB3cml0ZXMgdG8gdGhlIHRhcmdldCBzeXN0ZW0/IEkgdGhpbmsgdGhpcyBu
ZWVkcyB0byBiZSBpbXByb3ZlZCAuLi4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
