From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 2/7] RDMA/core: Add helper function to create
 named QPs
Date: Thu, 18 Jan 2018 03:22:29 +0000
Message-ID: <1516245748.3665.0.camel@wdc.com>
References: <20180115151255.30167-1-leon@kernel.org>
         <20180115151255.30167-3-leon@kernel.org> <1516138540.2844.36.camel@wdc.com>
         <20180117055942.GF13639@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117055942.GF13639-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <95A7920CE4BCCA43AF5D79DB1AF0E3C2-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTE3IGF0IDA3OjU5ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgSmFuIDE2LCAyMDE4IGF0IDA5OjM1OjQyUE0gKzAwMDAsIEJhcnQgVmFuIEFz
c2NoZSB3cm90ZToNCj4gPiBBZGRpdGlvbmFsbHksIHBsZWFzZSB1c2UgdGhlIGtlcm5lbC1kb2Mg
c3ludGF4IHRvIGRvY3VtZW50IHN0cnVjdHVyZSBtZW1iZXJzLg0KPiANCj4gS2VybmVsLWRvYyBj
aGVja2VyIGRvZXNuJ3Qgd29yayB3aXRoIHBhdGNoZXMgYW5kIGliX3ZlcmJzLmggZnVsbCBvZg0K
PiBrZXJuZWwtZG9jIHdhcm5pbmcuDQoNCkkgY2FuIHJldmlldyB0aGUga2VybmVsLWRvYyBzeW50
YXggZm9yIHlvdSBpZiB0aGUga2VybmVsLWRvYyBjaGVja2luZyBzY3JpcHQNCnRyaWdnZXJzIHRv
byBtYW55IHdhcm5pbmdzLg0KDQpCYXJ0Lg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
